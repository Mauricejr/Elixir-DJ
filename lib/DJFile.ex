defmodule DJ.DJFile do
  @timeOutAppend 1000
  @timeOutReadFile 5000
 
  use GenServer

    def start_link(:appendFile,todo_list_name,fileLocation,serverLocation) do
      GenServer.start_link(__MODULE__, {:appendFile,fileLocation,serverLocation}, name: String.to_atom(todo_list_name))
    end

    def start_link(:readFile,todo_list_name,fileLocation,serverLocation) do
         GenServer.start_link(__MODULE__, {:readFile,fileLocation,serverLocation}, name: String.to_atom(todo_list_name))
    end

    def init ({:appendFile,fileLocation,serverLocation}) do    
        Process.flag(:trap_exit, true)  
        file = File.open!(fileLocation) 
        Process.send_after(self,{:appendFile,serverLocation},@timeOutAppend)
        {:ok,{" ",file}}
    end

    def init ({:readFile,fileLocation,serverLocation}) do 
       Process.flag(:trap_exit, true)
       Process.send_after(self,{:readFile,fileLocation,serverLocation},@timeOutReadFile)
       {:ok," "}
    end

    def readAppendFile(state,file,server)do
        case IO.read(file, :line ) do
            :eof -> state
            value when  value != state ->     
                  value |> removeNumber |> IO.puts
                  value
            _ -> :ok
        end
    end

    def readOverrideFile(state,file,server)do
        case File.open(file, [:read]) do
             {:ok, body}  when  body != state ->
             value =IO.readline(body)
             File.close body
             IO.puts
           #sendMessage(value,server)
             value
           #_ -> state
             {:error, reason} ->  reason
        end
    end

    defp sendMessage(message, server) do  
         url ="http://#{server}:7380/parameter/pgm_0/enc/stream_metadata=#{String.replace(message, " ", "%20")}" 
       
        case HTTPoison.post(url, message, []) do                
          {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
            body                    
          {:ok, %HTTPoison.Response{status_code: 404}} ->
            "Not found :("                    
          {:error, %HTTPoison.Error{reason: reason}} ->
            reason
        end
    end

    def removeNumber(content) do
        String.replace(content,~r/^[0 - 9]+./, " ")
    end

    def handle_info({:appendFile,url}, state) do
        {v,f} = state
        newState = readAppendFile(v,f, url)
        Process.send_after(self,{:appendFile,url},@timeOutAppend)
        {:noreply, {newState,f}}
    end

    def handle_info({:readFile,file,server}, state) do
  	    newState = readOverrideFile(state,file, server)
        Process.send_after(self,{:readFile,file,server},@timeOutReadFile)
        {:noreply, {newState}}
    end

    def stop(pid) do
	      GenServer.call(pid,:stop)
    end

    def handle_call(:stop, _from, state) do
		    {:stop,:normal,:ok,state}
	  end

    def handle_call(:ERROR, state) do
      	{:stop,:normal,:ok,state}
    end

    def handle_info({:ERROR,mesage}, state) do
        IO.puts "got message #{mesage}"
        {:noreply, state}
    end

    def handle_info({:ERROR, test, :killed}, state) do
        IO.puts test
      	{:noreply, state}
    end

    def handle_info({:EXIT, test, reason}, state) do
        IO.puts test
      	{:stop, reason, state}
    end

    def terminate(reason, stats) do
      	IO.puts "server terminated because of #{inspect reason}"
      	inspect stats
          :ok
    end
end