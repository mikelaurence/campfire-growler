# Campfire Growl Notifier

## Sample Use
    $LOAD_PATH << '/src/ruby/campfire_growler' # Needs path to the library since this isn't gem-i-fied
    require 'campfire_growler'

    # Automatically starts up once instantiated
    CampfireGrowler.new :account => 'mycampfire', 
      :username => 'mklaurence@gmail.com', 
      :password => 'password', 
      :room => 'Room Of Champions',
      :interval => 120

## Notes

* In the network tab of your growl preferences, you *must* enable "Listen for incoming notifications" and "Allow remote application registration".

## How to setup automatic startup (in Mac OS)

The preferred way to initialize programs at boot time in Mac OS is to use a Launch Daemon. This involves placing a property list (plist) in your /Library/LaunchDaemons folder:

    <?xml version="1.0" encoding="UTF-8"?>
    	<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    	"http://www.apple.
    	com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    	<dict>  
    		<key>Label</key>
    		<string>Campfire Growler</string>
    		<key>ProgramArguments</key>
    		<array>
    			<string>/usr/local/bin/ruby</string>
    			<string>/Users/myuser/src/ruby/campfire-growler/mycampfire.rb</string>
    		</array>
    		<key>LowPriorityIO</key>
    		<true />
    		<key>Nice</key>
    		<integer>1</integer>
    		<key>StartInterval</key>
    		<integer>60</integer>
    	</dict>
    </plist>

Replace the first ProgramArgument with your path to Ruby. The second ProgramArgument should contain the path to the file containing your CampfireGrowler instantiation.

Finally, run:
    sudo launchctl load campfire-growler.plist
    sudo launchctl start campfire-growler.plist
    
Note that in the above plist, the StartInterval property is set, thus causing the ruby file to be run periodically. This would assume you are not supplying an interval to the CampfireGrowler object. If you do supply an interval, the growler will run itself in a periodical nature (using a while loop and the sleep command). Basically, the first way costs more in CPU bursts (because ruby & rubygems must be loaded on each call), whereas the second way will cost memory by keeping itself loaded. 

If you do prefer to just keep it in memory, take out the StartInterval line and its following integer line, and add an interval option to your CampfireGrowler initialization.

## LICENSE:

(The MIT License)

Copyright (c) 2009 Mike Laurence

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
