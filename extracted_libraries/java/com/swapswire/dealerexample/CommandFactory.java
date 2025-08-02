package com.swapswire.dealerexample;

import java.io. *;
import java.util. *;

public class CommandFactory
{
    public static void dumpCommands()
    {
        System.out.println("COMMANDS & PARAMETERS");

        Collection<DealerCmd> allCmds = commands.values();
        Iterator<DealerCmd>     iter = allCmds.iterator();
        while (iter.hasNext())
        {
            DealerCmd cmd = iter.next();
            cmd.dumpHelp();
        }
    }

    public static DealerCmd getCommand(String cmd)
    {
        System.out.println("Getting Command - " + cmd);
        return commands.get(cmd.toLowerCase());
    }

    private static Map<String, DealerCmd> commands = new TreeMap<String, DealerCmd>();

    private static void addCommand(DealerCmd cmd)
    {
        commands.put(cmd.getCommandName().toLowerCase(), cmd);
    }

    static {
        addCommand(new CommandInterpreterCmd());
        addCommand(new InfiniteLoopCmd());
        addCommand(new ChangePasswordCmd());
        addCommand(new SubmitNewDealCmd());
        addCommand(new SubmitNewPrimeBrokerDealCmd());
        addCommand(new SubmitBackloadCmd());
        addCommand(new SubmitDraftNewDealCmd());
        addCommand(new SubmitDraftNewPrimeBrokerDealCmd());
        addCommand(new AmendDraftPrimeBrokerDealCmd());
        addCommand(new SubmitCancellationCmd());
        addCommand(new SubmitCancellationExCmd());
        addCommand(new SubmitDraftCancellationCmd());
        addCommand(new SubmitDraftAmendmentCmd());
        addCommand(new SubmitPrimeBrokerAmendmentCmd());
        addCommand(new SubmitNovationCmd());
        addCommand(new AmendDraftCmd());
        addCommand(new DeleteDraftCmd());
        addCommand(new SendChatMessageCmd());
        addCommand(new PickupCmd());
        addCommand(new AcceptCmd());
        addCommand(new AcceptAffirmCmd());
        addCommand(new RejectDKCmd());
        addCommand(new RequestRevisionCmd());
        addCommand(new AffirmCmd());
        addCommand(new TransferCmd());
        addCommand(new WithdrawCmd());
        addCommand(new AcknowledgeCmd());
        addCommand(new ReleaseCmd());
        addCommand(new RejectDirectDealCmd());
        addCommand(new PullCmd());
        addCommand(new ValidateXMLCmd());
        addCommand(new GetDealSWMLCmd());
        addCommand(new GetDealSWDMLCmd());
        addCommand(new GetSWDMLfromSWMLCmd());
        addCommand(new GetLongSWDMLFromCSVCmd());
        addCommand(new GetPrivateDataXMLFromCSVCmd());
        addCommand(new GetMessageTextFromCSVCmd());
        addCommand(new GetDealInfoCmd());
        addCommand(new GetDealVersionHandleCmd());
        addCommand(new GetAllDealVersionHandlesCmd());
        addCommand(new GetDealStateCmd());
        addCommand(new GetActiveDealInfoCmd());
        addCommand(new QueryDealsCmd());
        addCommand(new QueryDefaultMismatchCmd());
        addCommand(new GetParticipantsCmd());
        addCommand(new GetAddressListCmd());
        addCommand(new GetLegalEntityListCmd());
        addCommand(new GetUserInfoCmd());
        addCommand(new GetBookListCmd());
        addCommand(new HelpCmd());
        addCommand(new StdinCmd());
        addCommand(new QuitCmd());
        addCommand(new SubmitBrokerDealCmd());
    }
}
