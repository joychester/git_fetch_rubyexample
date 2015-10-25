require 'git'
require 'fileutils'
require 'sys/proctable'

$: << File.expand_path(File.dirname(__FILE__))

git_repo = 'https://github.com/joychester/Arowana.git'

target_dir = './arowana'


if ! Dir.exist?(target_dir)
    p 'cloning the project from git repo...'
    g = Git.clone(git_repo, target_dir)
else
    p 'clean up the old repo found in local...'
    FileUtils.remove_entry(target_dir)
    p 'cloning the project from git repo...'
    g = Git.clone(git_repo, target_dir)
end

# exec 'bundle install and rackup config.ru'
Dir.chdir('./arowana') do
    `bundle install`
    
    # check postgresql service if running
    pg_service = Sys::ProcTable.ps.select { |process|
        process.include?('postgres')
    }
    if pg_service.empty?
        p 'please check your postgresql service if it is running, exiting...'
        exit(1)
    else
        p 'ready to start your Arowana App in C9.io[as this is c9.io example]'
        p 'in your local, you can type rackup config.ru directly to start'
        `rackup config.ru -p $PORT -o $IP`
    end
end
