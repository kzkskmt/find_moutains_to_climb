module RakeLoggerRails
  # rakeタスクでログを出力するとき、自動的にタグ付けを行う。
  #   task foo: :environment do
  #     logger.info('hello')  # Logs "[RAKE] [foo] hello"
  #   end
  def execute(*)
    if Rails.logger
      Rails.logger.tagged('RAKE', name) { super }
    else
      super
    end
  end
end
Rake::Task.prepend(RakeLoggerRails)

def logger
  Rails.logger
end