package com.swapswire.dealerexample;

public class GetParticipantsCmd extends DealerCmd {

    public GetParticipantsCmd() {
        super("GetParticipants", "participantQueryXML");
    }

    public static String run(Session session, String participantQueryXML) throws ErrorCode {
        System.out.println("GetParticipants");
        String[] resultXML = {new String()};
        DealerAPIWrapper.getParticipants(session.getLoginHandle(), participantQueryXML, resultXML);
        System.out.println("OK");
        System.out.println("Participant Commands - " + resultXML[0]);
        return resultXML[0];
    }

    public void process(String[] argv, Session session) throws ErrorCode {
        assert (argv.length >= 1);
        String participantQueryXML = argv[0];
        run(session, participantQueryXML);
    }
}
