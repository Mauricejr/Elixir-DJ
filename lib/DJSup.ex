defmodule DJ.DJSup do
		use Supervisor

	def start_link do
		Supervisor.start_link(__MODULE__, name: :DJSup)
	end

	def init(_) do
		worker_opts = [restart: :permanent]
		childrend = [worker(DJ.DJTwitter, worker_opts),supervisor(DJ.DJSupervisor, worker_opts)]
		opts = [strategy: :one_for_one]
		supervise(childrend,opts)
	end
end