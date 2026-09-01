import React from 'react'
import { render } from 'react-dom'
import HelpPage from "./../../scripts/swz-help.js"

render((<HelpPage helpType="resp" getHelpUrl="/resphelp/get" />), document.getElementById('content'));