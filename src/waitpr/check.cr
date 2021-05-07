require "json"

module WaitPR
  struct Check
    include JSON::Serializable

    getter name : String
    getter status : String
    getter conclusion : String
    @[JSON::Field(key: "detailsUrl")]
    getter url : String

    def finished?
      status == "COMPLETED"
    end

    def succeeded?
      conclusion == "SUCCESS"
    end

    def display
      case status
      when "QUEUED"
        "⏳"
      when "IN_PROGRESS"
        "⚙️"
      when "COMPLETED"
        case conclusion
        when "SUCCESS"
          "✅"
        when "FAILURE"
          "❌"
        else
          conclusion
        end
      end
    end
  end
end
