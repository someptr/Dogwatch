<!-- routify:options reset -->
<script>
	import { metatags, goto } from "@roxi/routify";

	import {
		isAuthenticated,
		authenticating,
		checkAuthCookie,
		liveValidation,
		statusModalMessages,
		newlyRegisteredEmail,
		loadLocale,
	} from "../../stores/state";
	const loc = loadLocale();
	metatags.title = loc.login.misc.pageTitle;
	metatags.description = "Description coming soon...";
	import { GraphQLClient, gql } from "graphql-request";

	import * as yup from "yup";

	const loginData = {
		email: null,
		password: null,
	};

	if ($newlyRegisteredEmail) {
		loginData.email = $newlyRegisteredEmail;
	}

	// charCode 13 (Enter/Return)
	function handleKeyPress(e) {
		if (e.charCode === 13) {
			handleSubmit();
		}
	}

	async function handleSubmit() {
		if (await validate(schema_login, loginData, loginValidationErrors)) {
			if (await login(loginData.email, loginData.password)) {
				$newlyRegisteredEmail = null;
				console.log("Login validation and Login process successful, we are about to redirect to /appointments...");
				$goto("/appointments");
				statusModalMessages.set({ code: 200, message: loc.login.modal.loginSuccess });
			} else {
				$authenticating = false;
				$statusModalMessages = { code: 400, message: loc.login.modal.loginFailed };
			}
		}
	}

	const login = async (email, password) => {
		authenticating.set(true);
		async function loginUser() {
			const endpoint = import.meta.env.VITE_GQL_ENDPOINT_URL;
			const graphQLClient = new GraphQLClient(endpoint, {
				credentials: "include",
				mode: "cors",
			});
			const mutation = gql`
				mutation {
					loginUser(email: "${email}", password: "${password}")
				}
			`;

			const data = await graphQLClient.request(mutation);
			if (data.loginUser.status === 200) {
				isAuthenticated.set(true);
				authenticating.set(false);
				console.log(data.loginUser);
				localStorage.setItem("firstDayOfWeek", data.loginUser.preferences.firstDayOfWeek);
				console.log(JSON.stringify(data, undefined, 2));
				return true;
			} else {
				throw new Error("Login Failed");
			}
		}

		return loginUser()
			.then(() => {
				return true;
			})
			.catch((error) => {
				console.log(error);
				isAuthenticated.set(false);
				return false;
			});
	};

	// ********************************************************
	// VALIDATION
	// ********************************************************

	// errors Frontend-Validation
	let loginValidationErrors = {};

	// ----------------------------------------------------
	// NEW APPOINTMENT SCHEMA
	// ----------------------------------------------------
	const schema_login = yup.object().shape({
		email: yup.string().email(loc.shared.val.emailInvalid).required(loc.shared.val.emailProvide).typeError(loc.shared.val.emailProvide),
		password: yup.string().required(loc.shared.val.pwdProvide).typeError(loc.shared.val.pwdProvide),
	});

	// ----------------------------------------------------
	// VALIDATION
	// ----------------------------------------------------
	const validate = async (schema, data, errors) => {
		try {
			await schema.validate(data, { abortEarly: false });
			// alert(JSON.stringify(get(data), null, 2));
			errors = {};
			loginValidationErrors = {};
			return true;
		} catch (err) {
			console.log(errors);
			errors = extractErrors(err);
			console.log(errors);
			loginValidationErrors = errors;
			$statusModalMessages = { code: 1, message: loc.shared.modal.missingFields };
			return false;
		}
	};

	// ----------------------------------------------------
	// EXTRACT VALIDATION ERRORS (FRONTEND)
	// ----------------------------------------------------
	function extractErrors(err) {
		return err.inner.reduce((acc, err) => {
			return { ...acc, [err.path]: err.message };
		}, {});
	}

	$: validateLive(loginData);
	function validateLive() {
		if ($liveValidation) {
			validate(schema_login, loginData, loginValidationErrors);
		}
	}
</script>

<!-- Login Index -->

<div class="headline">
	<h1 class="color-headline" style="margin-left: 0rem">{loc.login.misc.headline}</h1>
</div>
<div style="margin-top: -2rem" class="separator" />

<form>
	<label for="email">{loc.shared.labels.email}</label><br />
	<input class:selected={loginData.email} type="text" id="email" name="email" bind:value={loginData.email} />
	{#if loginValidationErrors.email}
		<p class="form-validation-error" style="margin-bottom: 2rem">({loginValidationErrors.email})</p>
	{/if}
	<label for="password">{loc.shared.labels.password}</label><br />
	<input class:selected={loginData.password} type="password" id="password" name="password" bind:value={loginData.password} on:keypress={handleKeyPress} />
	{#if loginValidationErrors.password}
		<p class="form-validation-error">({loginValidationErrors.password})</p>
	{/if}
</form>
<button on:click={handleSubmit} class="btn btn-regular">{loc.login.misc.submit}</button>

<div class="wrapper-to-register">
	<p>{loc.login.misc.infotext} <a class="generic" href="/register">{loc.login.misc.regLink}</a></p>
</div>

<style>
	#email {
		text-transform: lowercase;
	}

	.wrapper-to-register {
		font-size: 1.5rem;
		margin-top: 4rem;
		line-height: 150%;
	}

	input {
		border: 1px solid var(--dark);
		border-radius: 5px;
		padding-left: 1rem;
		margin-top: 0.5rem;
		margin-bottom: 1rem;
	}

	button {
		margin-top: 2rem;
		width: 100%;
	}
</style>
