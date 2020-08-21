import { JsonRpc } from 'eosjs';
import Table from 'react-bootstrap/Table';
import Container from 'react-bootstrap/Container';
import { Navbar, Row, Col } from 'react-bootstrap';

const rpc = new JsonRpc('http://nodeos:8888');

const Index = (props) => (

    <div>
        <Container fluid>
            <Row>
                <Col>
                    <Navbar expand="lg" variant="light" bg="light">
                        <Navbar.Brand href="#">Table</Navbar.Brand>
                    </Navbar>
                </Col>
            </Row>
            <Row>
                <Col>
                    <Table striped bordered hover variant="light">
                        <thead>
                            <tr>
                            <th>ID</th>
                            <th>Location</th>
                            <th>Updated</th>
                            </tr>
                        </thead>
                        <tbody>
                            {props.rows.map(row => 
                            <tr>
                                <td>{row.id}</td>
                                <td>{row.location}</td>
                                <td>{row.updated}</td>
                            </tr>
                            )}
                        </tbody>
                    </Table>
                </Col>
            </Row>
        </Container>
    </div>
);

Index.getInitialProps = async function() {
    const rows = await rpc.get_table_rows({
        json: true, code: 'tracker', scope: '', table: 'location', limit: 1000
    });
    return rows;
}

export default Index;