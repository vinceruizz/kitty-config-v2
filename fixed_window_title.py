"""Keep the native window title fixed, including launches without a session."""


def _pin_title(boss, window, data):
    boss.call_remote_control(
        window, ("set-os-window-title", "Kitty Terminal")
    )


# Resize runs on initial window creation as well as subsequent resizes.
on_resize = _pin_title
on_title_change = _pin_title
on_focus_change = _pin_title
