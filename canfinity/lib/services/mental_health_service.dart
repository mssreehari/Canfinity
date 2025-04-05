class MentalHealthService {
  static Future<String> getChatResponse(String userMessage) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Check for common cancer-related mental health questions
    String lowercaseMessage = userMessage.toLowerCase();

    if (lowercaseMessage.contains('anxious') ||
        lowercaseMessage.contains('anxiety') ||
        lowercaseMessage.contains('worried')) {
      return """Feeling anxious during cancer treatment is completely normal and valid. Here are some strategies that might help:

1. Deep breathing exercises - try breathing in for 4 counts, hold for 2, and out for 6
2. Progressive muscle relaxation - tensing and releasing muscle groups
3. Mindfulness meditation - even 5-10 minutes daily can help
4. Talk to someone you trust about your feelings
5. Consider speaking with a mental health professional who specializes in cancer patients

Remember that managing anxiety takes practice. Would you like me to explain any of these techniques in more detail?""";
    }

    if (lowercaseMessage.contains('depress') ||
        lowercaseMessage.contains('sad') ||
        lowercaseMessage.contains('hopeless')) {
      return """I'm sorry you're feeling this way. Many cancer patients experience depression during their journey. Some suggestions that might help:

1. Be gentle with yourself - you're going through something difficult
2. Try to maintain social connections, even if it's just short calls or messages
3. Speak with your cancer care team about how you're feeling
4. Consider professional support - many cancer centers have dedicated mental health professionals
5. Look for small moments of joy each day

If you're having thoughts of harming yourself, please contact a crisis hotline immediately or go to your nearest emergency room. Would you like to talk more about any of these points?""";
    }

    if (lowercaseMessage.contains('sleep') ||
        lowercaseMessage.contains('insomnia') ||
        lowercaseMessage.contains('tired')) {
      return """Sleep problems are very common during cancer treatment. Here are some tips that might help improve your sleep:

1. Try to maintain a consistent sleep schedule
2. Create a relaxing bedtime routine
3. Limit screen time before bed
4. Keep your bedroom cool, dark and quiet
5. Talk to your doctor about sleep issues - they might have specific recommendations
6. Consider gentle activities like yoga or walking during the day

Would you like more specific advice on any of these sleep strategies?""";
    }

    if (lowercaseMessage.contains('pain') ||
        lowercaseMessage.contains('hurt') ||
        lowercaseMessage.contains('ache')) {
      return """I'm sorry you're experiencing pain. While I can't provide medical advice, here are some general suggestions:

1. Be sure to communicate clearly with your healthcare team about your pain level
2. Keep a pain journal noting when pain occurs and what helps
3. Ask about pain management options - there are many approaches
4. Some find complementary techniques like guided imagery or gentle movement helpful
5. Consider talking to a pain specialist if pain persists

Remember that managing your pain is an important part of your treatment. Your medical team wants to help you with this.
""";
    }

    if (lowercaseMessage.contains('afraid') ||
        lowercaseMessage.contains('fear') ||
        lowercaseMessage.contains('scared')) {
      return """It's completely normal to feel afraid during cancer treatment. Here are some thoughts that might help:

1. Identify specific fears and discuss them with your healthcare team
2. Seek accurate information from reliable sources
3. Connect with others who understand through support groups
4. Focus on what you can control in your daily life
5. Practice grounding techniques when fear feels overwhelming
6. Consider professional support for managing fears

Would you like to share more about what specifically you're afraid of?""";
    }

    if (lowercaseMessage.contains('family') ||
        lowercaseMessage.contains('children') ||
        lowercaseMessage.contains('spouse') ||
        lowercaseMessage.contains('partner')) {
      return """Cancer affects the whole family, and navigating relationships during treatment can be challenging. Some thoughts:

1. Open, honest communication is important, even when difficult
2. Allow family members to help in ways that are meaningful
3. Consider family counseling or support groups
4. For children, provide age-appropriate information
5. Take moments to connect that don't revolve around cancer
6. Remember that your loved ones are processing their own emotions too

Would you like to discuss specific family situations?""";
    }

    if (lowercaseMessage.contains('food') ||
        lowercaseMessage.contains('eat') ||
        lowercaseMessage.contains('appetite') ||
        lowercaseMessage.contains('nausea')) {
      return """Changes in appetite and eating habits are common during cancer treatment. Here are some suggestions:

1. Try small, frequent meals rather than three large ones
2. Experiment with different foods and temperatures
3. Stay hydrated throughout the day
4. Consider protein-rich supplements if recommended
5. Ginger can help with mild nausea for some people
6. Speak with a dietitian who specializes in oncology

Have you found any foods that work better for you during treatment?""";
    }

    // Default responses for general questions or greetings
    if (lowercaseMessage.contains('hello') || lowercaseMessage.contains('hi')) {
      return "Hello! I'm here to support you. How are you feeling today?";
    }

    if (lowercaseMessage.contains('thank')) {
      return "You're welcome. I'm here to support you through your cancer journey.";
    }

    if (lowercaseMessage.contains('how are you')) {
      return "I'm here and ready to listen and help you. How are you feeling today?";
    }

    // Generic response for other queries
    return """I'm here to support you through your cancer journey. You can talk to me about feelings of anxiety, depression, fear, or ask for coping strategies. 

What specifically are you concerned about today? I can help with:
- Managing anxiety and stress
- Coping with depression
- Sleep problems
- Pain management strategies
- Family and relationship concerns
- Nutrition and appetite issues
- Treatment side effects

Please feel free to share how you're feeling or what's on your mind.""";
  }
}
