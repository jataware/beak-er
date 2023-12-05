import json
import logging
import re

from archytas.tool_utils import AgentRef, LoopControllerRef, tool, toolset

from beaker_kernel.lib.agent import BaseAgent
from beaker_kernel.lib.context import BaseContext

logging.disable(logging.WARNING)  # Disable warnings
logger = logging.Logger(__name__)


@toolset()
class OceananigansToolset:
    """
    Toolset used for working with the Julia package Oceananigans, a fast, friendly, flexible software package for finite volume simulations of the nonhydrostatic and hydrostatic Boussinesq equations on CPUs and GPUs.
    """

    @tool()
    async def generate_code(
        self, query: str, agent: AgentRef, loop: LoopControllerRef
    ) -> None:
        """
        Generated Julia code to be run in an interactive Jupyter notebook for the purpose of creating simulations in Oceananigans.

        Input is a full grammatically correct question about or request for an action to be performed with the Julia language or Oceananigans.

        Args:
            query (str): A fully grammatically correct queistion about the current model.
        """
        prompt = f"""
You are a programmer writing code to help with writing simulations in Julia and Oceananigans.jl.

Please write code that satisfies the user's request below.

Please generate the code as if you were programming inside a Jupyter Notebook and the code is to be executed inside a cell.
You MUST wrap the code with a line containing three backticks (```) before and after the generated code.
No addtional text is needed in the response, just the code block.
"""

        llm_response = await agent.oneshot(prompt=prompt, query=query)
        loop.set_state(loop.STOP_SUCCESS)
        preamble, code, coda = re.split("```\w*", llm_response)
        result = json.dumps(
            {
                "action": "code_cell",
                "language": "julia-1.9",
                "content": code.strip(),
            }
        )
        return result


class OceananigansAgent(BaseAgent):

    def __init__(self, context: BaseContext = None, tools: list = None, **kwargs):
        tools = [OceananigansToolset]
        super().__init__(context, tools, **kwargs)
