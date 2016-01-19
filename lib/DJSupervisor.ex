defmodule DJ.DJSupervisor do
use Supervisor


	def start_link(_) do
		Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
	end

	def start_child({:readFile,todo_list_name}) do
		fileLocation = "/nowplaying_radiodj.txt"
		serverLocation = "serverloactio" 
		Supervisor.start_child(__MODULE__,[:readFile,todo_list_name,fileLocation,serverLocation])
	end

	def start_child({:appendFile,todo_list_name}) do
		fileLocation = "/nowplaying_radiodj.txt"
		serverLocation = "serverloactio" 
		Supervisor.start_child(__MODULE__,[:appendFile,todo_list_name,fileLocation,serverLocation])
	end

	def init(_) do
		supervise([worker(DJ.DJFile, [],restart: :transient) ],strategy: :simple_one_for_one)
	end
end
