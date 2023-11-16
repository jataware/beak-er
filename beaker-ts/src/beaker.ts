import { SessionContext } from '@jupyterlab/apputils';
import {
	// ServerConnection,
	KernelManager,
	KernelSpecManager,
	SessionManager
} from '@jupyterlab/services';
import { ServerConnection } from '@jupyterlab/services/lib/serverconnection';
import { Kernel, KernelConnection } from '@jupyterlab/services/lib/kernel';
import {IKernelConnection} from '@jupyterlab/services/lib/kernel/kernel'
import * as messages from '@jupyterlab/services/lib/kernel/messages';
import { JSONObject } from '@lumino/coreutils';
import { v4 as uuidv4 } from 'uuid';


// Lower case states to match the naming in the messages.
export enum KernelState {
	unknown = 'unknown',
	starting = 'starting',
	idle = 'idle',
	busy = 'busy',
	terminating = 'terminating',
	restarting = 'restarting',
	autorestarting = 'autorestarting',
	dead = 'dead'
}

export const createMessageId = (msgType: string): string => {
	const uuid = uuidv4().replaceAll('-', '').slice(0, 16);
	return `beaker-${uuid}-${msgType}`;
};

export namespace BeakerConnection {

    interface ISettings extends ServerConnection.ISettings {
        // Beaker specific settings to go here

    }

    export function makeSettings(serverSettings?: Partial<ServerConnection.ISettings>): ISettings {
        return ServerConnection.makeSettings(serverSettings);
    }

}

export interface IBeakerHeader extends messages.IHeader {
    msg_type: any
}

export interface IBeakerMessage extends messages.IShellMessage {
    header: IBeakerHeader;
    channel: "shell";
    content: JSONObject;
}

export interface IBeakerFuture extends Kernel.IShellFuture {

}

const msg1: IBeakerMessage = {
    buffers: null,
    content: {
        "foo": "bar"
    },
    channel: "shell",

    /**
     * The message header.
     */
    header: {
        date: "foo321",
        /**
         * Message id, typically UUID, must be unique per message
         */
        msg_id: "foo123",
        /**
         * Message type
         */
        msg_type: "llm_query",
        /**
         * Session id, typically UUID, should be unique per session.
         */
        session: "foo",
        /**
         * The user sending the message
         */
        username: "none",
        /**
         * The message protocol version, should be 5.1, 5.2, 5.3, etc.
         */
        version: "5.3",
    },
    /**
     * Metadata associated with the message.
     */
    metadata: {},
    /**
     * The parent message
     */
    parent_header: null,
}

export class BeakerKernelConnection extends KernelConnection {
  sendBeakerMessage(
    msg: IBeakerMessage,
    expectReply = false,
    disposeOnDone = true
  ): IBeakerFuture {
    const future = this.sendShellMessage(
       msg,
       true,
       true
    );
    return future;
  }
}

export class BeakerSession {

    constructor(options?: {
        settings: any;
        name: string;
        kernelName: string;
    }) {
        this._serverSettings = ServerConnection.makeSettings(options.settings);
		this._kernelManager = new KernelManager({
			serverSettings: this._serverSettings
		});
		this._sessionManager = new SessionManager({
			kernelManager: this._kernelManager,
			serverSettings: this._serverSettings
		});
		this._specsManager = new KernelSpecManager({
			serverSettings: this._serverSettings
		});

        this._sessionContext = new SessionContext({
            sessionManager: this._sessionManager,
            specsManager: this._specsManager,
            name: options.name,
            kernelPreference: {
                name: options.kernelName
            }
        });

        this._sessionContext.initialize();

    }

    get session(): SessionContext {
        return this._sessionContext;
    }

    get kernel(): BeakerKernelConnection {
        return (this._sessionContext.kernel) as BeakerKernelConnection;
    }

    private _serverSettings;
    private _kernelManager;
    private _sessionManager;
    private _specsManager;
    private _sessionContext;

}
