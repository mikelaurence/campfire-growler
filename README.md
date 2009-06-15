# Campfire Growl Notifier

## Sample Use

`
# Automatically starts up once instantiated
CampfireGrowler.new :account => 'mycampfire', 
  :username => 'mklaurence@gmail.com', 
  :password => 'password', 
  :room => 'Room Of Champions'
`

## Notes

In the network tab of your growl preferences, you *must* enable "Listen for incoming notifications" and "Allow remote application registration".

## How to setup automatic startup (in Mac OS)

The preferred way to initialize programs at boot time in Mac OS is to use a Launch Daemon. This involves placing a property list (plist) in your /Library/LaunchDaemons folder:

`
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
			<string>/opt/local/bin/ruby</string>
			<string>/Users/myuser/src/ruby/campfire-growler/mycampfire.rb</string>
		</array>
		<key>LowPriorityIO</key>
		<true />
		<key>Nice</key>
		<integer>1</integer>
		<key>StartInterval</key>
		<integer>360</integer>
	</dict>
</plist>
`

Replace the first ProgramArgument with your path to Ruby, but be careful - I have four ruby binaries on my system (according to 'where'), and only one worked with rubygems (you may want to try running your file using the full ruby path before rebooting to see if it works). The second ProgramArgument is the path to the file containing your CampfireGrowler instantiation.

Finally, run:
`
sudo launchctl load campfire-growler.plist
sudo launchctl start campfire-growler.plist
`




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