import json
import logging
import re

from archytas.tool_utils import AgentRef, LoopControllerRef, tool

from beaker_kernel.lib.agent import BaseAgent
from beaker_kernel.lib.context import BaseContext


logger = logging.getLogger(__name__)


class BeakAgent(BaseAgent):
    """
    You are an programming assistant to aid a developer working in a Jupyter notebook by answering their questions and helping write code for them based on their
    prompt.

    If the user asks you to do something that reasonably could be performed using code, you should default to use the `generate_code` tool.
    """


    @tool()
    async def generate_code(self, code_request: str, agent: AgentRef, loop: LoopControllerRef):
        """
        Generated Python code to be run in an interactive Jupyter notebook.

        Input is a full grammatically correct question about or request for an action to be performed in the current environment.
        If you need more information on how to accomplish the request, you should use the other tools prior to using this one.

        Args:
            code_request (str): A fully grammatically correct question about the current model.
        """

        code_generation_prompt = f"""
DO NOT USE A TOOL to generate the code. The code should be generated by the LLM and not by a tool.

Please generate {self.context.subkernel.DISPLAY_NAME} code to satisfy the user's request below.

Request:
```
{code_request}
```

Please generate the code as if you were programming inside a Jupyter Notebook and the code is to be executed inside a cell.
You MUST wrap the code with a line containing three backticks (```) before and after the generated code.
No addtional text is needed in the response, just the code block.
""".strip()

        response = await agent.query(code_generation_prompt)
        preamble, code, coda = re.split("```\w*", response)
        loop.set_state(loop.STOP_SUCCESS)

        result = {
            "action": "code_cell",
            "language": self.context.subkernel.SLUG,
            "content": code.strip(),
        }

        return json.dumps(result)
