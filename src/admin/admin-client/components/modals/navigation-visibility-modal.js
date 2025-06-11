import * as utils from '../../../../utils/client';
import * as constants from '../../../../utils/constants';
import React from 'react';
import { connect } from 'react-redux';
import { Button, Modal, ModalHeader, ModalBody, Row, Col } from 'reactstrap';
import { closeModal, updateNavigationVisibility } from '../../actions';
import axios from 'axios';

class NavigationVisibilityModal extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      backdrop: true,
      isVisible: (this.props.showPointNav !== '0') && (this.props.showPuzzleNav !== '0')
    }

    this.close = this.close.bind(this);
    this.updateNavigationVisibility = this.updateNavigationVisibility.bind(this);
  }

  close() {
    this.props.closeModal();
  }

  async updateNavigationVisibility(e) {
    let val = parseInt(e.currentTarget.value);
    let isVisible = val === constants.ON;

    const config = {
      method: 'POST',
      url: '/admin/navigation-visibility',
      data: {
        isVisible: isVisible
      }
    };
    
    utils.simpleAxios(axios, config).then(() => {
      this.setState({ isVisible });
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
            <label>네비게이션 설정</label>
          </div>
        </ModalHeader>
        <ModalBody>
          <Row>
            <Col xs="12">
              <div className="navigation-visibility d-flex align-items-center">
                <label className="mr-3">포인트/구역 메뉴 표시 : </label>
                <div className="radio abc-radio abc-radio-primary mr-3 d-flex align-items-center">
                  <input 
                    type="radio" 
                    id="navigationVisibilityRadioInput01" 
                    onChange={this.updateNavigationVisibility} 
                    checked={this.state.isVisible} 
                    value={constants.ON}
                  />
                  <label htmlFor="navigationVisibilityRadioInput01">ON</label>
                </div>
                <div className="radio abc-radio abc-radio-danger d-flex align-items-center">
                  <input 
                    type="radio" 
                    id="navigationVisibilityRadioInput02" 
                    onChange={this.updateNavigationVisibility} 
                    checked={!this.state.isVisible} 
                    value={constants.OFF}
                  />
                  <label htmlFor="navigationVisibilityRadioInput02">OFF</label>
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