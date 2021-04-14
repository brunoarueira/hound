module Config
  class Clippy < Base
    def serialize
      Serializer.yaml(content)
    end
  end
end
