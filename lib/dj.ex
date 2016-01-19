defmodule DJ do
  use Application

    def start(_t, _s) do
      DJ.DJSup.start_link
    end
    
    def start_childrend({:readFile,starr_childern}) do
      DJ.DJSupervisor.start_child({:readFile,starr_childern})
    end

    def start_childrend({:appendFile,starr_childern}) do
      DJ.DJSupervisor.start_child({:appendFile,starr_childern})
    end
end
