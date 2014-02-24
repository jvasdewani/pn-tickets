class PersonScore
  def initialize(guid, state)
    @guid = guid
    @state = state
  end

  def increment
    $dalli.with do |client|
      client.set key, new_score
    end
  end

  def score
    $dalli.with do |client|
      @score ||= client.get(key) || 0
    end
  end

  private

  def new_score
    score + 1
  end

  def key
    time = Time.now.beginning_of_day.to_i
    "#{@guid}-#{time}-#{@state}"
  end
end
