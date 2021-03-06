defmodule GroupherServer.Test.Mutation.JobReaction do
  use GroupherServer.TestTools

  alias GroupherServer.CMS

  setup do
    {:ok, job} = db_insert(:job)
    {:ok, user} = db_insert(:user)

    guest_conn = simu_conn(:guest)
    user_conn = simu_conn(:user, user)

    {:ok, ~m(user_conn guest_conn job user)a}
  end

  describe "[job star]" do
    @query """
    mutation($id: ID!, $action: ReactableAction!, $thread: ReactThread!) {
      reaction(id: $id, action: $action, thread: $thread) {
        id
      }
    }
    """
    test "login user can star a job", ~m(user_conn job)a do
      variables = %{id: job.id, thread: "JOB", action: "STAR"}
      created = user_conn |> mutation_result(@query, variables, "reaction")

      assert created["id"] == to_string(job.id)
    end

    test "unauth user star a job fails", ~m(guest_conn job)a do
      variables = %{id: job.id, thread: "JOB", action: "STAR"}

      assert guest_conn
             |> mutation_get_error?(@query, variables, ecode(:account_login))
    end

    @query """
    mutation($id: ID!, $action: ReactableAction!, $thread: ReactThread!) {
      undoReaction(id: $id, action: $action, thread: $thread) {
        id
      }
    }
    """
    test "login user can undo star a job", ~m(user_conn job user)a do
      {:ok, _} = CMS.reaction(:job, :star, job.id, user)

      variables = %{id: job.id, thread: "JOB", action: "STAR"}
      updated = user_conn |> mutation_result(@query, variables, "undoReaction")

      assert updated["id"] == to_string(job.id)
    end

    test "unauth user undo star a job fails", ~m(guest_conn job)a do
      variables = %{id: job.id, thread: "JOB", action: "STAR"}

      assert guest_conn
             |> mutation_get_error?(@query, variables, ecode(:account_login))
    end
  end
end
