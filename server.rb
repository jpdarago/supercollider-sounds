require 'rubygems'
require 'json'
require 'json/add/core'
require 'osc-ruby'
require 'osc-ruby/em_server'
require 'em-websocket'

@connections = []
NoteMsg = Struct.new(:note, :duration) do
    def to_json(*a)
        map = Hash.new
        self.members.each do |m|
            map[m] = self[m]
        end
        map.to_json(*a)
    end
end

@server = OSC::EMServer.new( 3333 )
@server.add_method '/note' do | msg |
    if @connections.length > 0 then
        note, duration = msg.to_a
        notemsg = NoteMsg.new(note,duration)
        notejson = JSON.fast_generate notemsg

        @connections.each do |conn|
            conn.send notejson
        end
    end
end

EM.run do
    @server.run
    EM::WebSocket.run(:host => "127.0.0.1", :port => 8080) do |ws|
        ws.onopen do |handshake|
            @connections << ws
        end
        ws.onclose do
            @connections.delete ws
        end
    end
end
