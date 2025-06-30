import * as utils from '../../../../utils/client';
import * as constants from '../../../../utils/constants';
import React from 'react';
import { connect } from 'react-redux';
import { Button, Modal, ModalHeader, ModalBody, Row, Col } from 'reactstrap';
import { closeModal, updateNavigationVisibility } from '../../actions';
import axios from 'axios';

const ICON_MODE = {
  THREE: '3_ICONS',
  FIVE: '5_ICONS'
};

class NavigationVisibilityModal extends React.Component {
  constructor(props) {
    super(props);
    console.log('NavigationVisibilityModal props:', {
      showPointNav: this.props.showPointNav,
      showPuzzleNav: this.props.showPuzzleNav
    });
    
    const isFiveIcons = (this.props.showPointNav !== false) && (this.props.showPuzzleNav !== false);
    console.log('isFiveIcons calculation:', isFiveIcons);
    
    this.state = {
      backdrop: true,
      iconMode: isFiveIcons ? ICON_MODE.FIVE : ICON_MODE.THREE
    }
    
    console.log('Initial iconMode state:', this.state.iconMode);

    this.close = this.close.bind(this);
    this.handleIconModeChange = this.handleIconModeChange.bind(this);
  }

  close() {
    this.props.closeModal();
  }

  async handleIconModeChange(e) {
    const newMode = e.currentTarget.value;
    const isVisible = newMode === ICON_MODE.FIVE;

    const config = {
      method: 'POST',
      url: '/admin/navigation-visibility',
      data: {
        isVisible: isVisible
      }
    };
    
    utils.simpleAxios(axios, config).then(() => {
      this.setState({ iconMode: newMode });
      this.props.updateNavigationVisibility(isVisible);
      alert("성공");
    }).catch(error => {
      console.error('Navigation visibility update failed:', error);
      alert("설정 변경에 실패했습니다.");
    });
  }

  render() {
    return (
      <Modal isOpen={ (this.props.activeModalClassName == this.props.className) ? true : false } toggle={this.close} className={this.props.className}>
        <ModalHeader toggle={this.close}>
          <div className="l-left">
            <label>아이콘 설정</label>
          </div>
        </ModalHeader>
        <ModalBody>
          <Row>
            <Col xs="12">
              <div className="navigation-visibility d-flex align-items-center">
                <label className="mr-3">아이콘 개수 : </label>
                <div className="radio abc-radio abc-radio-primary mr-3 d-flex align-items-center">
                  <input 
                    type="radio" 
                    id="iconModeRadio3" 
                    name="iconMode"
                    onChange={this.handleIconModeChange} 
                    checked={this.state.iconMode === ICON_MODE.THREE} 
                    value={ICON_MODE.THREE}
                  />
                  <label htmlFor="iconModeRadio3">3개아이콘</label>
                </div>
                <div className="radio abc-radio abc-radio-primary d-flex align-items-center">
                  <input 
                    type="radio" 
                    id="iconModeRadio5"
                    name="iconMode"
                    onChange={this.handleIconModeChange} 
                    checked={this.state.iconMode === ICON_MODE.FIVE} 
                    value={ICON_MODE.FIVE}
                  />
                  <label htmlFor="iconModeRadio5">5개아이콘</label>
                </div>
              </div>
            </Col>
          </Row>
        </ModalBody>
      </Modal>
    );
  }
}

function mapStateToProps(state, ownProps) {
  return {
    activeModalClassName : state.modalControl.activeModalClassName,
    showPointNav: state.showPointNav !== '0',
    showPuzzleNav: state.showPuzzleNav !== '0',
    isNavigationVisible: state.navigationVisibility.isNavigationVisible
  };
}

export default connect(mapStateToProps, { closeModal, updateNavigationVisibility })(NavigationVisibilityModal);