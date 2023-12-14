import logging

from archytas.react import Undefined
from archytas.tool_utils import AgentRef, LoopControllerRef, is_tool, tool
from beaker_kernel.lib.agent import BaseAgent
from beaker_kernel.lib.context import BaseContext


logger = logging.getLogger(__name__)

class Toolset:
    """My Toolset"""


    # retrieve_documentation.__doc__

class PyPackageAgent(BaseAgent):
    def __init__(self, context: BaseContext = None, tools: list = None, **kwargs):
        tools = []
        libraries = {
        }
        super().__init__(context, tools, **kwargs)

    @tool()
    async def retrieve_sourcecode(
        self, target: str, agent: AgentRef, loop: LoopControllerRef
    ) -> str:
        """
        This function retrieves the source code about a Python module.

        You should use this to discover what is available within a package and determine the proper syntax and functionality on how to use the code.
        Querying against the module or package should list all avialable submodules and functions that exist, so you can use this to discover available
        functions and the query the function to get usage information.

        Args:
            target (str): Python package, module or function for which documentation is requested
        Returns:
            str: The contents of the source code file that contains this
        """
        code = f'''
try:
    import {target}
except ImportError:
    pass
help({target})
'''
        r = await agent.context.evaluate(code)
        return str(r)

    @tool()
    async def retrieve_documentation(
        self, target: str, agent: AgentRef, loop: LoopControllerRef
    ) -> str:
        """
        This function retrieves documentation about a Python module.

        You should use this to discover what is available within a package and determine the proper syntax and functionality on how to use the code.
        Querying against the module or package should list all avialable submodules and functions that exist, so you can use this to discover available
        functions and the query the function to get usage information.

        Args:
            target (str): Python package, module or function for which documentation is requested
        Returns:
            str: The help text of the python package
        """
        code = f'''
try:
    import {target}
except ImportError:
    pass
help({target})
'''
        r = await agent.context.evaluate(code)
        return str(r)
