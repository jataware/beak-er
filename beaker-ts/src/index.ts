// @ts-ignore: Include extension code to extend typing from Jupyterlabs
import extension from './extension';
if (extension === undefined) {
    throw new Error("Unable to extend Jupyterlab types");
}

export {
    type IBeakerSessionOptions,
    BeakerSession,
} from './session';

export {
    type BeakerCellType,
    BeakerBaseCell,
    BeakerRawCell,
    BeakerCodeCell,
    BeakerMarkdownCell,
    BeakerQueryCell,
    BeakerNotebook,
    BeakerNotebookContent,
} from './notebook';

export {
    type IBeakerHistory,
    type IBeakerHistoryEvent,
    type IBeakerHistoryExecutionEvent,
    type IBeakerHistoryQueryEvent,
} from './history';
