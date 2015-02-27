require 'fileutils'

Kintama.on_start do
  @moneta_dir = "#{__dir__}/../../lib/queue/lib/moneta"
  @backup_moneta_dir = "#{__dir__}/../../lib/queue/lib/moneta.backup"
  FileUtils.mv @moneta_dir, @backup_moneta_dir, force: true
end

Kintama.on_finish do
  FileUtils.rm_rf @moneta_dir
  FileUtils.mv @backup_moneta_dir, @moneta_dir
end
