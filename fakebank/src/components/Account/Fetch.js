import { React, useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import axios from 'axios';
import jwt_decode from "jwt-decode";
import { Accordion, Container, Row, Col } from 'react-bootstrap';
import useToken from '../../useToken';

export default function Fetch() {
    const { state } = useLocation();
    const { q } = state;
    const [accounts, setAccounts] = useState("");
    const { token } = useToken();
    var decodedToken = jwt_decode(token);

    useEffect(() => {
        axios
          .get('http://localhost:8081/api/proxy/accounts/'+decodedToken.preferred_username+'/'+q)
          .then((res) => {
            setAccounts(res.data.accounts);
          })
          .catch((err) => console.log(err));
      }, []);  
      const cards = {};
      for (const account of accounts) {
        if (account.friendlyName in cards) {
          cards[account.friendlyName].push(account);
        } else {
          cards[account.friendlyName] = [account];
        }
      }

    return(
        <Accordion>
            {Object.entries(cards).map((entry) => {
                const card = entry[0];
                const details = entry[1];
                return (
                <Accordion.Item eventKey={card} key={card}>
                    <Accordion.Header>{card}</Accordion.Header>
                    <Accordion.Body>
                    <Container>
                        <Row>
                        <Col sm={3}>Credit Card Number</Col>
                        <Col sm={3}>{details[0].ccNumber}</Col>
                        </Row>
                        <Row>
                        <Col sm={3}>CVV</Col>
                        <Col sm={3}>{details[0].cvv}</Col>
                        </Row>
                        <Row>
                        <Col sm={3}>Expiry Date</Col>
                        <Col sm={3}>{details[0].expDate}</Col>
                        </Row>
                    </Container>              
                    </Accordion.Body>
                </Accordion.Item>
            );
        })}
        </Accordion>
    )
}