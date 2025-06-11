import { UPDATE_NAVIGATION_VISIBILITY } from './types';

export const updateNavigationVisibility = (isVisible) => dispatch => {
  dispatch({
    type: UPDATE_NAVIGATION_VISIBILITY,
    payload: isVisible
  });
}