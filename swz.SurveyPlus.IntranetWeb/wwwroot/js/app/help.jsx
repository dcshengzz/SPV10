import React from 'react'
import { render } from 'react-dom'
import HelpPage from "./../../scripts/swz-help.js"


render(
    (<HelpPage helpType="admin" getHelpUrl="/help/get" />),
    document.getElementById('content'));