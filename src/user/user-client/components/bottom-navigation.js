import React, { Component, Fragment } from 'react';
import { NavLink } from 'react-router-dom';
import cn from 'classnames';
import MapIcon from '@material-ui/icons/Map';
import ChartIcon from '@material-ui/icons/InsertChartOutlined';
import PuzzleIcon from '@material-ui/icons/Dashboard';
import UploadIcon from '@material-ui/icons/Camera';
import PostInfoIcon from '@material-ui/icons/InfoSharp';

class BottomNavigation extends Component {
  constructor(props) {
    super(props);
    this.state = {
      activePage : 'map'
    }
  }
  render() {
    let rippleCN = cn({
      ripple: true,
      ripple__circle: true
    });

    const showPointNav = this.props.showPointNav !== '0';
    const showPuzzleNav = this.props.showPuzzleNav !== '0';

    return (
      <div className="bottom-navigation">
        <NavLink to="/user/page/map">
          <div className="icon"><MapIcon /></div>
          <div className="text">지도</div>
          <div className={rippleCN}></div>
        </NavLink>
        
        {showPointNav && (
          <NavLink to="/user/page/point">
            <div className="icon"><ChartIcon /></div>
            <div className="text">포인트</div>
            <div className={rippleCN}></div>
          </NavLink>
        )}
        
        {showPuzzleNav && (
          <NavLink to="/user/page/puzzle">
            <div className="icon"><PuzzleIcon /></div>
            <div className="text">구역</div>
            <div className={rippleCN}></div>
          </NavLink>
        )}
        
        <NavLink to="/user/page/upload">
          <div className="icon"><UploadIcon /></div>
          <div className="text">업로드</div>
          <div className={rippleCN}></div>
        </NavLink>
        <NavLink to="/user/page/post-info">
          <div className="icon"><PostInfoIcon /></div>
          <div className="text">포스트</div>
          <div className={rippleCN}></div>
        </NavLink>
      </div>
    );
  }
}

export default BottomNavigation;