import '../entities/chat_message.dart';

abstract class CampusAIRepository {
  /// Send a message to the Campus Oracle AI and get the response
  /// Returns a ChatMessage on success or a Failure on error
  Future<ChatMessage> sendMessage(String message, List<ChatMessage> context);

  /// Get the conversation history between the user and Campus Oracle
  /// Returns a list of ChatMessages on success or a Failure on error
  Future<List<ChatMessage>> getConversationHistory();

  /// Clear the conversation history
  /// Returns void on success or a Failure on error
  Future<void> clearConversation();
}
