function encodeHtml(html) {
    const node = document.createElement('div');
    node.appendChild(document.createTextNode(html));
    return node.innerHTML;
}

export { encodeHtml }
