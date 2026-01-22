class AgentNotifications::ConversationNotificationsMailer < ApplicationMailer
  def conversation_creation(conversation, agent, _user)
    return unless smtp_config_set_or_development?

    @agent = agent
    @conversation = conversation
    inbox_name = @conversation.inbox&.sanitized_name
    subject = "#{@agent.available_name}, Se ha creado una nueva conversación [ID - #{@conversation.display_id}] en #{inbox_name}."
    @action_url = app_account_conversation_url(account_id: @conversation.account_id, id: @conversation.display_id)
    send_mail_with_liquid(to: @agent.email, subject: subject) and return
  end

  def conversation_assignment(conversation, agent, _user)
    return unless smtp_config_set_or_development?

    @agent = agent
    @conversation = conversation
    subject = "#{@agent.available_name}, Se te ha asignado una nueva conversación [ID - #{@conversation.display_id}]."
    @action_url = app_account_conversation_url(account_id: @conversation.account_id, id: @conversation.display_id)
    send_mail_with_liquid(to: @agent.email, subject: subject) and return
  end

  def conversation_mention(conversation, agent, message)
    return unless smtp_config_set_or_development?

    @agent = agent
    @conversation = conversation
    @message = message
    subject = "#{@agent.available_name}, Has sido mencionado en la conversación [ID - #{@conversation.display_id}]"
    @action_url = app_account_conversation_url(account_id: @conversation.account_id, id: @conversation.display_id)
    send_mail_with_liquid(to: @agent.email, subject: subject) and return
  end

  def assigned_conversation_new_message(conversation, agent, message)
    return unless smtp_config_set_or_development?
    # Don't spam with email notifications if agent is online
    return if ::OnlineStatusTracker.get_presence(message.account_id, 'User', agent.id)

    @agent = agent
    @conversation = conversation
    subject = "#{@agent.available_name}, Nuevo mensaje en tu conversación asignada [ID - #{@conversation.display_id}]."
    @action_url = app_account_conversation_url(account_id: @conversation.account_id, id: @conversation.display_id)
    send_mail_with_liquid(to: @agent.email, subject: subject) and return
  end

  def participating_conversation_new_message(conversation, agent, message)
    return unless smtp_config_set_or_development?
    # Don't spam with email notifications if agent is online
    return if ::OnlineStatusTracker.get_presence(message.account_id, 'User', agent.id)

    @agent = agent
    @conversation = conversation
    subject = "#{@agent.available_name}, Nuevo mensaje en una conversación en la que participas [ID - #{@conversation.display_id}]."
    @action_url = app_account_conversation_url(account_id: @conversation.account_id, id: @conversation.display_id)
    send_mail_with_liquid(to: @agent.email, subject: subject) and return
  end

  private

  def liquid_droppables
    super.merge({
                  user: @agent,
                  conversation: @conversation,
                  inbox: @conversation.inbox,
                  message: @message
                })
  end
end

AgentNotifications::ConversationNotificationsMailer.prepend_mod_with('AgentNotifications::ConversationNotificationsMailer')
