import { createGlobalStyle } from 'styled-components';

export default createGlobalStyle`

    @import url('https://fonts.googleapis.com/css2?family=Titillium+Web&display=swap');

    * {
        margin: 0;
        padding: 0;
        outline: 0;
        box-sizing: border-box;
    }

    body {
        user-select: none;
        background-color: transparent;
    }

    #app {
        width: 100%;
        height: 100%;
        background-color: #e5e5e5;
        font-family: 'Titillium Web', sans-serif;
    }

`;