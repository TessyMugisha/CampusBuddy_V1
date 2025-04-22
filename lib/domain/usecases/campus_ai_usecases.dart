import '../entities/chat_message.dart';
import '../repositories/campus_ai_repository.dart';

/// Send a message to Campus Oracle
class SendMessageUseCase {
  final CampusAIRepository repository;

  SendMessageUseCase(this.repository);

  Future<ChatMessage> call(String message, List<ChatMessage> context) async {
    return await repository.sendMessage(message, context);
  }
}

/// Get conversation history with Campus Oracle
class GetConversationHistoryUseCase {
  final CampusAIRepository repository;

  GetConversationHistoryUseCase(this.repository);

  Future<List<ChatMessage>> call() async {
    return await repository.getConversationHistory();
  }
}

/// Clear conversation history with Campus Oracle
class ClearConversationUseCase {
  final CampusAIRepository repository;

  ClearConversationUseCase(this.repository);

  Future<void> call() async {
    return await repository.clearConversation();
  }
}
