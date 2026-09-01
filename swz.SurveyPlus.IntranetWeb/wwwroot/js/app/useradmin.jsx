import React from 'react'
import { render } from 'react-dom'
import CloverAdmin from './../../scripts/swz-useradmin.js'

const superAdminRole = 'Admins'; //Select your admin role to be excluded in system

render(
    <CloverAdmin
        apiUrl="/configapiuseradmin"
        imageFolder="/images/"
        superAdminRoles={[superAdminRole]}
        deltaWidth={0}
        deltaHeight={0}
        returnToAppUrl="/"
    />,
    document.getElementById('content')
);




