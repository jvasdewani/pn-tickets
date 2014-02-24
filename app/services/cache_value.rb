class CacheValue
  include Sidekiq::Worker

  def perform(issue_id)
    @issue = Issue.find(issue_id)
    comments = @issue.comments.ordered.reverse
    @latest_response = comments.first
    @gap_response = comments.second

    cache_status
    cache_priority
    if @gap_response
      cache_response_time
      cache_issue_time
    end
    Indexing.perform_async(@issue.id)
  end

  private

  def cache_status
    case @latest_response._ns.to_i
    when 10
      @issue.update_attribute :status, 'resolved'
    when 20
      @issue.update_attribute :status, 'on_hold'
    when 30
      @issue.update_attribute :status, 'open'
    end
  end

  def cache_priority
    case @latest_response._np.to_i
    when 10
      @issue.update_attribute :priority, 'low'
    when 20
      @issue.update_attribute :priority, 'normal'
    when 30
      @issue.update_attribute :priority, 'high'
    when 40
      @issue.update_attribute :priority, 'critical'
    end
  end

  def cache_response_time
    unless @issue.comments.length > 2
      @issue.update_attribute :response_time_cache, @gap_response.created_at.business_time_until(@latest_response.created_at).to_i
    end
  end

  def cache_issue_time
    if @issue.comments.count >= 2
      unless @gap_response._np.to_i <= 20
        @issue.update_attribute :issue_time_cache, @issue.issue_time_cache + @gap_response.created_at.business_time_until(@latest_response.created_at).to_i
      end
    end
  end
end
