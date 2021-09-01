export default { // https://github.com/calumari/fivem-react-boilerplate/blob/master/src/util/Nui.js

    async send(event, data = {}) {
        return fetch(`https://fivem-vehicleshop/${event}`, {
            method: 'post',
            headers: {
                'Content-type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(data)
        });
    },

    emulate(type, data = null) {
        window.dispatchEvent(
            new MessageEvent('message', {
                data: { type, data }
            })
        );
    }
};