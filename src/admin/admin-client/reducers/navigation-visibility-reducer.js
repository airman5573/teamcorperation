import { UPDATE_NAVIGATION_VISIBILITY } from '../actions/types';

export default function(state = {
  isNavigationVisible: true
}, action) {
  switch( action.type ) {
    case UPDATE_NAVIGATION_VISIBILITY:
      return Object.assign({}, state, {
        isNavigationVisible: action.payload
      });
      
    default: 
      return state;
  }
}