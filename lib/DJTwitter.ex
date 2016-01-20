defmodule DJ.DJTwitter do
 use GenServer

		def start_link(_) do
		    GenServer.start_link(__MODULE__, name: :twitter)
		end

		def init (_) do 
			IO.puts "starting twitter"
			Process.flag(:trap_exit, true)
		    {:ok,""}
		end

		def updateStatus(message) do
			IO.puts message
		end

		def readFile do
		    file = "/nowplaying_radiodj.txt"
		    twitterStatue = readTwitterUpdateStateFile
	        IO.puts twitterStatue

	    	case File.read(file) do
		    	 {:ok, body}      ->  Enum.join([body, " ", twitterStatue]) |> IO.puts
		    	 {:error, reason} -> IO.puts ":error"
		    end
		end

		def readTwitterUpdateStateFile do
		    file = "/nowplaying_twistter.txt"
		    
		    case File.read(file) do
		   		 {:ok, body}      -> body
		   		 {:error, reason} -> IO.puts ":error"
		    end
		end

		def twitterUpdateStatus(message) do
	        IO.puts message
		    #ExTwitter.update(message)
		end

		def stop(pid) do
		    GenServer.call(pid,:stop)
		end

		def handle_call(:stop, _from, state) do
		    {:stop,:normal,:ok,state}
		end

		def terminate(reason, stats) do
		    inspect stats 
		    :ok
		end
end
