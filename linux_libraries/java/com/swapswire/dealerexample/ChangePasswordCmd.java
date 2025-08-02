package com.swapswire.dealerexample;

public class ChangePasswordCmd extends DealerCmd {

    public ChangePasswordCmd() {
        super("ChangePassword", "oldPassword newPassword", "Change the existing logged in user's password.");
    }

    public static void run(Session session, String oldPwd, String newPwd) throws ErrorCode {
        System.out.println("Changing password from " + oldPwd + " to " + newPwd);
        DealerAPIWrapper.changePassword(session.getSessionHandle(), session.getUsername(), oldPwd, newPwd);
        System.out.println("Password changed OK");
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 2);
        String oldPwd = argv[0];
        String newPwd = argv[1];
        run(session, oldPwd, newPwd);
    }
}
