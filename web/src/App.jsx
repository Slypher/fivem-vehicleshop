import React, { useState, useMemo } from 'react';

import { Button, Typography, Container, Paper, InputBase, AppBar, Toolbar } from '@material-ui/core';

import SearchIcon from '@material-ui/icons/Search';

import { makeStyles, alpha } from '@material-ui/core/styles';

import styled from 'styled-components';

import Nui from './util/Nui'

const Main = styled(Container)`
    position: relative;
    padding-bottom: 40px;

    > div {
        margin: 25px 0 0;
        padding: 30px;
    }
`;

const Title = styled(Typography)`
    text-align: center;
    font-size: 25px;
    margin-bottom: 10px;
`;

const CardsContainer = styled.div`
    display: flex;
    flex-wrap: wrap;
    margin: 0 -10px 0;

    @media (max-width: 900px) {
        display: block;
    }
`;

const CardContainer = styled.div`
    flex: 1;
    margin: 20px 10px 0;
    border-radius: 10px;
    box-shadow: 0 0 1em #00000033;

    @media (max-width: 900px) {
        margin-bottom: 20px;
    }
`;

const CardImage = styled.img`
    width: 100%;
    pointer-events: none;
    border-radius: 10px 10px 0px 0px;
`;

const CardTitle = styled.p`
    width: 100%;
    margin: 15px 0px 0px;
    padding: 0 20px;

    font-weight: bold;
    font-size: 25px;
`;

const Description = styled.div`
    width: 100%;
    margin-top: 5px;
    padding: 0px 20px;
`;

const Footer = styled.div`
    display: flex;
    align-items: center;
    width: 100%;
    padding: 20px 20px;
`;

const Price = styled.p`
    flex: 1;
    color: #3C81D6;
    font-size: 25px;
    font-weight: bold;
`;

const useStyles = makeStyles((theme) => ({
    grow: {
        flexGrow: 1,
    },
    title: {
        display: 'none',
        [theme.breakpoints.up('sm')]: {
            display: 'block',
        },
    },
    search: {
        position: 'relative',
        borderRadius: theme.shape.borderRadius,
        backgroundColor: alpha(theme.palette.common.white, 0.15),
        '&:hover': {
            backgroundColor: alpha(theme.palette.common.white, 0.25),
        },
        marginRight: theme.spacing(2),
        marginLeft: 0,
        width: '100%',
        [theme.breakpoints.up('sm')]: {
            marginLeft: theme.spacing(3),
            width: 'auto',
        },
    },
    searchIcon: {
        padding: theme.spacing(0, 2),
        height: '100%',
        position: 'absolute',
        pointerEvents: 'none',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
    },
    inputRoot: {
        color: 'inherit',
    },
    inputInput: {
        padding: theme.spacing(1, 1, 1, 0),
        // vertical padding + font size from searchIcon
        paddingLeft: `calc(1em + ${theme.spacing(4)}px)`,
        transition: theme.transitions.create('width'),
        width: '100%',
        [theme.breakpoints.up('md')]: {
            width: '20ch',
        },
    },
    sectionDesktop: {
        display: 'none',
        [theme.breakpoints.up('md')]: {
            display: 'flex',
        },
    },
    sectionMobile: {
        display: 'flex',
        [theme.breakpoints.up('md')]: {
            display: 'none',
        },
    },
}));

const formatPrice = (value) => (new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
})).format(value);

function App() {

    const [hidden, hideCatalog] = useState(true)

    const [vehicles, updateVehicleTable] = useState([])

    const buyVehicle = (vehicleName) => {
        Nui.send('fivem-vehicleshop:buyVehicle', vehicleName)
    }

    const closeCatalog = () => {
        hideCatalog(true)
        updateVehicleTable([])
        Nui.send('fivem-vehicleshop:resetNuiFocus', {})
    }

    window.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            closeCatalog()
        }
    });

    window.addEventListener('message', function (event) {
        const eventData = event.data;

        if (eventData.type === 'SHOW_CATALOG') {
            hideCatalog(false)
            updateVehicleTable(eventData.vehicles)
        } else if (eventData.type === 'CLOSE_CATALOG') {
            closeCatalog()
        };
    });

    const [inputResult, searchVehicle] = useState('');

    const vehiclesList = useMemo(() => {

        const lowerInputResult = inputResult.toLowerCase();

        return vehicles.filter((vehicle) =>
            (vehicle.name).toString().toLowerCase().includes(lowerInputResult)
        );

    }, [inputResult, vehicles]);

    const classes = useStyles();

    return (
        <div id='app' hidden={hidden}>
            <div className={classes.root}>
                <AppBar position='static'>
                    <Toolbar>
                        <Typography className={classes.title} variant='h6' noWrap>
                            Vehicle Shop
                        </Typography>
                        <div className={classes.search}>
                            <div className={classes.searchIcon}>
                                <SearchIcon />
                            </div>
                            <InputBase
                                placeholder='Procurar Veículo'
                                classes={{
                                    root: classes.inputRoot,
                                    input: classes.inputInput,
                                }}
                                inputProps={{ 'aria-label': 'search' }}
                                type='text'
                                value={inputResult}
                                onChange={
                                    (ev) => searchVehicle(ev.target.value)
                                }
                            />
                        </div>
                    </Toolbar>
                </AppBar>
            </div>
            <Main maxWidth='md'>
                <Paper>
                    <Title>Catálogo de Veículos</Title>
                    <CardsContainer>
                        {vehiclesList.map((vehicle, idx) => (
                            <CardContainer key={idx}>
                                <CardImage src={`./images/${vehicle.name}.png`} />
                                <CardTitle>
                                    {vehicle.label}
                                </CardTitle>
                                <Description>
                                    <p>{`Estoque: ${vehicle.stock}`}</p>
                                </Description>
                                <Footer>
                                    <Price>
                                        {formatPrice(vehicle.price)}
                                    </Price>
                                    <Button
                                        variant='contained'
                                        color='primary'
                                        onClick={() => buyVehicle(vehicle.name)}
                                        disabled={vehicle.stock > 0 ? false : true}
                                    >
                                        {vehicle.stock > 0 ? 'Comprar' : 'Sem estoque'}
                                    </Button>
                                </Footer>
                            </CardContainer>
                        ))}
                    </CardsContainer>
                </Paper>
            </Main>
        </div>
    );
}

export default App;