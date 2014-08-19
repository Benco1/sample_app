function updateCountdown() {
    // 140 is the max message length
    var remaining = 140 - jQuery('#micropost_content').val().length;
    jQuery('.countdown').text(remaining + ' characters remaining');
}

jQuery(document).ready(function($) {
    updateCountdown();
    $('#micropost_content').change(updateCountdown);
    $('#micropost_content').keyup(updateCountdown);
    $('#micropost_content').on('page:change', updateCountdown);
});

// Seems to need a function to relaod page upon navigating away from and
// back to an incomplete post. Perhaps make use of `location.reload();` ..?