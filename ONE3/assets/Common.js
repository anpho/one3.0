function onPopTransitionEnded(page, next) {
	page.destroy();
	if (next) {
		try {
			next();
		} catch (e) {

		}

	}
}
function onPushTransitionEnded(page, next) {
	Application.menuEnabled = false;
	if (page.setActive) {
		page.setActive();
	}
	if (next) {
		try {
			next();
		} catch (e) {

		}
	}
}