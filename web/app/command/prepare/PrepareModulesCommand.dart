import 'package:framework/framework.dart';

import '../../../consts/modules/PipeChannel.dart';
import '../../module/DataProcessorJunctionMediator.dart';

class PrepareModulesCommand extends AsyncCommand {

  @override
  void execute( INotification note ) async {
    print("> StartupCommand -> PrepareModulesCommand > note: $note");

    PipeAwareModule applicationModule = note.getBody() as PipeAwareModule;
    PipeAwareModule dataProcessorModule = PipeAwareModule( Facade( "data.processor.module" ));

    IPipeFitting applicationOutputPipe = Pipe( Pipe.newChannelID() );
    IPipeFitting applicationInputPipe = Pipe( Pipe.newChannelID() );

    dataProcessorModule.facade.registerMediator( DataProcessorJunctionMediator( Junction() ));

    applicationModule.acceptInputPipe( PipeChannel.FROM_DATA_PROCESSOR, applicationInputPipe );
    applicationModule.acceptOutputPipe( PipeChannel.TO_DATA_PROCESSOR, applicationOutputPipe );

//    dataProcessorModule.acceptInputPipe( PipeChannel.TO_DATA_PROCESSOR, MergePipe() );
//    dataProcessorModule.acceptOutputPipe( PipeChannel.FROM_DATA_PROCESSOR, SplitPipe() );

    dataProcessorModule.acceptInputPipe( PipeChannel.TO_DATA_PROCESSOR, applicationOutputPipe );
    dataProcessorModule.acceptOutputPipe( PipeChannel.FROM_DATA_PROCESSOR, applicationInputPipe );

    commandComplete();
  }
}
