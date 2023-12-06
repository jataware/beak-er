import json
import logging
import os
from typing import TYPE_CHECKING, Any, Dict

import requests

from beaker_kernel.lib.context import BaseContext
from beaker_kernel.lib.jupyter_kernel_proxy import JupyterMessage

from .agent import OceananigansAgent

if TYPE_CHECKING:
    from beaker_kernel.kernel import LLMKernel
    from beaker_kernel.lib.subkernels.base import BaseSubkernel


logger = logging.getLogger(__name__)


class OceananigansContext(BaseContext):

    slug = "oceananigans"
    agent_cls = OceananigansAgent

    def __init__(self, beaker_kernel: "LLMKernel", subkernel: "BaseSubkernel", config: Dict[str, Any]) -> None:
        self.target = "oceananigan"
        self.intercepts = {
            "save_data_request": (self.save_data_request, "shell"),
        }
        self.reset()
        super().__init__(beaker_kernel, subkernel, self.agent_cls, config)


    async def setup(self, config, parent_header):
        await self.execute(self.get_code("setup"))
        print("Oceananigans creation environment set up")


    async def post_execute(self, message):
        await self.send_oceananigans_preview_message(parent_header=message.parent_header)

    def reset(self):
        pass

    async def auto_context(self):
        return """You are an scientific modeler whose goal is to help the user

Please answer any user queries to the best of your ability, but do not guess if you are not sure of an answer.
If you are asked to write code, please use the generate_code tool.
"""

    async def save_data(self, server, target_stream, data):
        message = JupyterMessage.parse(data)
        content = message.content

        result = await self.evaluate(
            self.get_code("save_data", 
                {
                    "dataservice_url": os.environ["DATA_SERVICE_URL"], 
                    "name": content.get("name"),
                    "description": content.get("description", ""),
                    "filenames": content.get("filenames"),
                }
            ),
        )

        self.beaker_kernel.send_response(
            "iopub", "save_data_response", result["return"], parent_header=message.header
        )
        await self.send_oceananigans_preview_message(parent_header=message.header)

