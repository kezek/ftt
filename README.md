ftt
===

Freshbyte Task Tracker

If you're not Freshbyter then look away . This will help us track our tasks , simple as that . 

I've settled with using Ruby + FXRuby. 

Installation
------------
- ~~gem install <github.com/downloads/sfeu/wxruby/wxruby-ruby19-2.0.2-x86-linux.gem> (for Ubuntu 12.04+)~~
- gem install fxruby
- gem install google_drive
- gem install sqlite3

Usage instructions
------------------
- the app will save a new row every time you hit 'Save' in your first worksheet
- there is no dynamic mapping based on column names , so it will assume your header row has this structure :
[Date |	User | Project | Task | Jira number or comments | Hours | Details]
- you must commit at least 15 min of work in order to save the row

------------------
These guys have been VERY helpful :

- https://github.com/gimite/google-drive-ruby

- https://github.com/sfeu/wxruby

(Other sources that I simply forgot)


