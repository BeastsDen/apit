package com.swapswire.dealerexample;

import com.swapswire.sw_api.SWAPILinkModule;

public class InfiniteLoopCmd extends DealerCmd {

    public InfiniteLoopCmd() {
        super("InfiniteLoop", "", "Sit in infinite loop displaying any notifications.");
    }

    public static void run(Session session) throws ErrorCode {
        ErrorCode ret = new ErrorCode(SWAPILinkModule.SWERR_Success);
        //session.registerCallbacks();
        do {
            try {
                DealerAPIWrapper.poll(120, 60);
            } catch (ErrorCode err) {
                ret = err;
            }
            if (!session.isValidClientSession()) {
                session.deregisterCallbacks();
                session.disconnect();
                session.connect();
                /*if (session.isValidClientSession()) {
                    session.registerCallbacks();
                }*/
            }
        } while (ret.isSuccess() || ret.isTimeout());
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        run(session);
    }
}
