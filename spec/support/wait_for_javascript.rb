module WaitForJavascript
  # Wait for the page to be 'complete' before performing any actions.
  # This is useful for ensuring that the page is fully loaded and elements
  # requiring javascript for interaction are ready.
  #
  # @return [void]
  def wait_for_javascript
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop do
        ready_state = evaluate_script('document.readyState')
        break if ready_state == 'complete'

        sleep 0.1
      end
    end
  end
end
