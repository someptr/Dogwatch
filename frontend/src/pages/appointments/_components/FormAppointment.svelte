<!-- TERMINE index -->
<script>
	import { goto, metatags, redirect } from "@roxi/routify";
	metatags.title = "Dogwatch / Termine / Hinzufügen";
	metatags.description = "Description coming soon...";
	import { onMount, onDestroy } from "svelte";
	import * as yup from "yup";
	import { GraphQLClient, gql } from "graphql-request";

	import { menuSelection, menuContext, bottomBarAction, liveValidation, statusModalMessages, lastSelectedDay, loadLocale } from "../../../stores/state";
	import { dateToString, leadingZero, yyyymmddToString, ISO8601ToJSDate, JSDateToISO8601 } from "../../../_helpers/helperFunctions";

	import randomColor from "randomcolor"; // import the script

	let extractedYear;
	let extractedMonth;
	let extractedDay;

	const loc = loadLocale();

	if (!$lastSelectedDay.dayId) {
		console.log("none");
		$goto("/appointments");
	}

	// formContext can be "add" or "edit"
	export let formContext;
	export let toUpdateAppointmentData;

	let appointmentData = {
		dogs: [],
		caretaker: null,
		observers: [],
		start_date: null,
		end_date: null,
		notes: null,
	};

	let fetchedDogs = [];
	let selectedDog = null;
	let dropdownSelectDogs;

	let fetchedContacts = [];

	let selectedCaretaker = null;
	let dropdownSelectCaretaker;

	let selectedObserver = null;
	let dropdownSelectObserver;

	$: titleDate = dateToString(appointmentData.start_date, appointmentData.end_date, "noYear");

	let titleDate;

	// ********************************************************
	// ON MOUNT
	// ********************************************************
	onMount(() => {
		console.log("lastSelected", $lastSelectedDay.dayId);
		if ($lastSelectedDay.dayId) {
			menuSelection.set("appointments");
			menuContext.set({ context: "appointment_add" });
			bottomBarAction.set("");
			liveValidation.set(false);
			if (formContext === "add") {
				extractedYear = parseInt($lastSelectedDay.dayId.slice(0, 4));
				extractedMonth = parseInt($lastSelectedDay.dayId.slice(4, 6));
				extractedDay = parseInt($lastSelectedDay.dayId.slice(6, 8));
				startDate_date = `${extractedYear}-${leadingZero(extractedMonth)}-${leadingZero(extractedDay)}`;
				console.log("Value passed to Datepicker:-----------", startDate_date);
				appointmentData.start_date = new Date(extractedYear, extractedMonth - 1, extractedDay).toISOString();
				console.log("startDate on mount", appointmentData.start_date);
			}
			initFetch();
		} else {
			$goto("/appointments");
		}
	});

	function onAppointmentDataToUpdate() {
		appointmentData = toUpdateAppointmentData;
		console.log(appointmentData.start_date);
		appointmentData.start_date = new Date(parseInt(appointmentData.start_date));
		appointmentData.end_date = new Date(parseInt(appointmentData.end_date));
		const extracted_start_date = new Date(appointmentData.start_date);
		const extracted_end_date = new Date(appointmentData.end_date);

		startDate_time = {
			hour: String(leadingZero(extracted_start_date.getHours())),
			minute: String(leadingZero(extracted_start_date.getMinutes())),
		};
		endDate_time = {
			hour: String(leadingZero(extracted_end_date.getHours())),
			minute: String(leadingZero(extracted_end_date.getMinutes())),
		};

		startDate_date = JSDateToISO8601(appointmentData.start_date);
		endDate_date = JSDateToISO8601(appointmentData.end_date);
		if (appointmentData.caretaker) {
			fetchedContacts = fetchedContacts.filter((element) => element.id !== appointmentData.caretaker.id);
		}

		appointmentData.observers.forEach((observer) => {
			fetchedContacts = fetchedContacts.filter((element) => element.id !== observer.id);
		});
		fetchedContacts.sort();

		appointmentData.dogs.forEach((dog) => {
			fetchedDogs = fetchedDogs.filter((element) => element.id !== dog.id);
			fetchedDogs.sort();
		});
	}

	// used as proxy so we can call this onMount() and await in markup
	async function initFetch() {
		const data = await getData();
		if (data) {
			fetchedDogs = data.dogs;
			fetchedContacts = data.contacts;
		}
		if (toUpdateAppointmentData) {
			onAppointmentDataToUpdate();
		}
		return;
	}

	// ********************************************************
	// FETCH DATA
	// ********************************************************
	async function getData() {
		async function getUser() {
			const endpoint = import.meta.env.VITE_GQL_ENDPOINT_URL;
			const graphQLClient = new GraphQLClient(endpoint, {
				credentials: "include",
				mode: "cors",
			});
			const query = gql`
				query {
					getUser {
						dogs {
							id
							name
						}
						contacts {
							id
							username
						}
					}
				}
			`;
			const data = await graphQLClient.request(query);
			console.log(JSON.stringify(data, undefined, 2));
			return data.getUser;
		}
		return await getUser()
			.then((data) => {
				console.log("form appointment data", data);
				if (!data.dogs && !data.contacts) {
					//// TODO!!!!!  redirect not working!!!

					console.log("we got no data, we redirect");
					$goto("/login");
				} else {
					console.log("FormAppointment got data", data.dogs);
					return data;
				}
			})
			.catch((error) => console.error(error));
	}

	// ********************************************************
	// FORM DATA
	// ********************************************************
	// ----------------------------------------------------
	// DOGS
	// ----------------------------------------------------

	function addDog() {
		if (selectedDog) {
			appointmentData.dogs = [selectedDog, ...appointmentData.dogs];
			fetchedDogs = fetchedDogs.filter((element) => element !== selectedDog);
			fetchedDogs.sort();
			dropdownSelectDogs.selectedIndex = 0;
			selectedDog = null;
		}
	}

	function addAllDogs() {
		appointmentData.dogs = [...appointmentData.dogs, ...fetchedDogs];
		fetchedDogs = [];
		dropdownSelectDogs.selectedIndex = 0;
	}

	function removeDog(dog) {
		appointmentData.dogs = appointmentData.dogs.filter((element) => element !== dog);
		fetchedDogs = [...fetchedDogs, dog];
		fetchedDogs.sort();
		selectedDog = null;
	}

	// ----------------------------------------------------
	// CARETAKER
	// ----------------------------------------------------
	function addCaretaker() {
		if (selectedCaretaker) {
			if (appointmentData.caretaker !== null) {
				fetchedContacts = [...fetchedContacts, appointmentData.caretaker];
				fetchedContacts.sort();
			}
			appointmentData.caretaker = selectedCaretaker;
			console.log(appointmentData);
			fetchedContacts = fetchedContacts.filter((element) => element !== selectedCaretaker);
			fetchedContacts.sort();
			dropdownSelectCaretaker.selectedIndex = 0;
			selectedCaretaker = null;
		}
	}

	function removeCaretaker(caretaker) {
		appointmentData.caretaker = null;
		fetchedContacts = [...fetchedContacts, caretaker];
		fetchedContacts.sort();
		selectedCaretaker = null;
	}

	// ----------------------------------------------------
	// OBSERVERS
	// ----------------------------------------------------

	function addObserver() {
		if (selectedObserver) {
			appointmentData.observers = [selectedObserver, ...appointmentData.observers];
			fetchedContacts = fetchedContacts.filter((element) => element !== selectedObserver);
			fetchedContacts.sort();
			dropdownSelectObserver.selectedIndex = 0;
			selectedObserver = null;
		}
	}

	function removeObserver(observer) {
		appointmentData.observers = appointmentData.observers.filter((element) => element !== observer);
		fetchedContacts = [...fetchedContacts, observer];
		fetchedContacts.sort();
		selectedObserver = null;
	}

	// ----------------------------------------------------
	// START DATE
	// ----------------------------------------------------

	let startDate_date;
	let startDate_time = { hour: null, minute: null };

	function setStartdate() {
		if (startDate_time.hour && startDate_time.minute && startDate_date) {
			const date = ISO8601ToJSDate(startDate_date);
			const year = date.getFullYear();
			const month = date.getMonth();
			const day = date.getDate();
			const dateToSave = new Date(year, month, day, parseInt(startDate_time.hour), parseInt(startDate_time.minute));
			appointmentData.start_date = dateToSave.toISOString();
		}
	}

	// ----------------------------------------------------
	// END DATE
	// ----------------------------------------------------

	let endDate_date;
	let endDate_time = { hour: null, minute: null };

	function setEnddate() {
		if (endDate_time.hour && endDate_time.minute && endDate_date) {
			const date = ISO8601ToJSDate(endDate_date);
			const year = date.getFullYear();
			const month = date.getMonth();
			const day = date.getDate();
			const dateToSave = new Date(year, month, day, parseInt(endDate_time.hour), parseInt(endDate_time.minute));
			appointmentData.end_date = dateToSave.toISOString();
		}
	}

	// ********************************************************
	// VALIDATION
	// ********************************************************

	// errors Frontend-Validation
	let appointmentValidationErrors = {};

	// ----------------------------------------------------
	// NEW APPOINTMENT SCHEMA
	// ----------------------------------------------------
	const schema_appointment = yup.object().shape({
		dogs: yup.array().of(
			yup.object().shape({
				id: yup.number().required(),
				name: yup.string().required(),
			})
		),

		caretaker: yup
			.object()
			.shape({
				id: yup.number().required(),
				username: yup.string().required(),
			})
			.nullable(),

		observers: yup.array().of(
			yup.object().shape({
				id: yup.number().required(),
				username: yup.string().required(),
			})
		),
		start_date: yup
			.date()
			.required(loc.appointments.val.startDateProvide)
			.required(yup.ref("end_date"), loc.appointments.val.endDateProvide)
			.typeError(loc.appointments.val.startDateProvide),
		end_date: yup
			.date()
			.required(loc.appointments.val.endDateProvide)
			.required(yup.ref("start_date"), loc.appointments.val.startDateProvide)
			.typeError(loc.appointments.val.endDateProvide)
			.min(yup.ref("start_date"), loc.appointments.val.endDateLTstartDate),
		notes: yup.string().nullable(),
	});
	// ----------------------------------------------------
	// VALIDATION
	// ----------------------------------------------------
	const validate = async (schema, data, errors) => {
		try {
			await schema.validate(data, { abortEarly: false });
			// alert(JSON.stringify(get(data), null, 2));
			errors = {};
			appointmentValidationErrors = {};
			return true;
		} catch (err) {
			errors = extractErrors(err);
			appointmentValidationErrors = errors;
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

	$: validateLive(appointmentData);
	function validateLive() {
		if ($liveValidation) {
			validate(schema_appointment, appointmentData, appointmentValidationErrors);
		}
	}

	// ********************************************************
	// Write TO DB
	// ********************************************************

	async function writeAppointmentToDB() {
		if (await validate(schema_appointment, appointmentData, appointmentValidationErrors)) {
			async function writeAppointment() {
				const endpoint = import.meta.env.VITE_GQL_ENDPOINT_URL;
				const graphQLClient = new GraphQLClient(endpoint, {
					credentials: "include",
					mode: "cors",
				});

				let caretakerId;
				if (appointmentData.caretaker === null) {
					caretakerId = null;
				} else {
					caretakerId = appointmentData.caretaker.id;
				}

				appointmentData.color = randomColor({
					luminosity: "light",
					hue: "random",
				});

				const dogIds = [];
				appointmentData.dogs.forEach((dog) => {
					dogIds.push(parseInt(dog.id));
				});

				if (!appointmentData.notes) {
					appointmentData.notes = "";
				}

				const observerIds = [];
				appointmentData.observers.forEach((observer) => {
					observerIds.push(parseInt(observer.id));
				});

				const mutation = gql`
			    mutation {
			        addAppointment(
                        start_date: "${appointmentData.start_date}",
                        end_date: "${appointmentData.end_date}",
			            caretaker: ${caretakerId},
                        observers: ${JSON.stringify(observerIds)},
			            dogs: ${JSON.stringify(dogIds)},
                        notes: "${appointmentData.notes}",
                        color: "${appointmentData.color}"
			        ){
						id
                        status
			        }
			    }
			`;
				const data = await graphQLClient.request(mutation);
				if (data.addAppointment.status.code === 200) {
					statusModalMessages.set({ code: 200, message: loc.appointments.modal.addSuccess });
				} else if (data.addAppointment.status.code === 401) {
					statusModalMessages.set({ code: 401, message: loc.shared.modal.notLoggedIn });
				} else {
					statusModalMessages.set({ code: 1, message: loc.shared.modal.unknownError });
				}
				console.log(JSON.stringify(data, undefined, 2));
				return data.addAppointment;
			}
			writeAppointment()
				.then((appointment) => {
					console.log(appointment);
					$goto("/appointments");
				})
				.catch((error) => console.error(error));
		} else {
			return false;
		}
	}

	async function updateAppointmentInDB() {
		if (
			(await validate(schema_appointment, appointmentData, appointmentValidationErrors)) &&
			startDate_time.hour &&
			startDate_time.minute &&
			endDate_time.hour &&
			endDate_time.minute
		) {
			async function writeAppointment() {
				const endpoint = import.meta.env.VITE_GQL_ENDPOINT_URL;
				const graphQLClient = new GraphQLClient(endpoint, {
					credentials: "include",
					mode: "cors",
				});

				let caretakerId;
				if (appointmentData.caretaker === null) {
					caretakerId = null;
				} else {
					caretakerId = appointmentData.caretaker.id;
				}

				const dogIds = [];
				appointmentData.dogs.forEach((dog) => {
					dogIds.push(parseInt(dog.id));
				});

				const observerIds = [];
				appointmentData.observers.forEach((observer) => {
					observerIds.push(parseInt(observer.id));
				});

				const mutation = gql`
			    mutation {
			        updateAppointment(
                        id: ${appointmentData.id},
                        start_date: "${appointmentData.start_date}",
                        end_date: "${appointmentData.end_date}",
			            caretaker: ${caretakerId},
                        observers: ${JSON.stringify(observerIds)},
			            dogs: ${JSON.stringify(dogIds)},
                        notes: "${appointmentData.notes}",
			        ){
						id
						status
                        caretaker {
                            id
                            username
                        }
                        observers {
                            id
                            username
                        }
			        }
			    }
			`;
				const data = await graphQLClient.request(mutation);
				if (data.updateAppointment.status.code === 200) {
					statusModalMessages.set({ code: 200, message: loc.appointments.modal.updateSuccess });
				} else if (data.updateAppointment.status.code === 401) {
					statusModalMessages.set({ code: 401, message: loc.shared.modal.notLoggedIn });
				} else {
					statusModalMessages.set({ code: 1, message: loc.shared.modal.unknownError });
				}
				console.log(JSON.stringify(data, undefined, 2));
				return data.updateAppointment;
			}
			writeAppointment()
				.then((appointment) => {
					$goto("/appointments");
				})
				.catch((error) => console.error(error));
		} else {
			return false;
		}
	}

	$: {
		if ($bottomBarAction === "appointment_save") {
			console.log("trying to write Appointment to DB...");
			$bottomBarAction = "";
			if (formContext === "add") {
				writeAppointmentToDB();
			}
			if (formContext === "edit") {
				updateAppointmentInDB();
			}
		}
	}

	// ********************************************************
	// ON DESTROY
	// ********************************************************

	onDestroy(() => {
		console.log("onDestroy() addAppointment");
		$liveValidation = false;
		console.log(appointmentData);
	});
</script>

{#await initFetch}
	<div class="wrapper-spinner">
		<div class="lds-ring">
			<div />
			<div />
			<div />
			<div />
		</div>
	</div>
{:then}
	<div class="wrapper">
		<div class="headline debug-border">
			<p class="h1 color-headline">{titleDate}</p>
			{#if $lastSelectedDay.dayId}
				<p class="headline-label">{$lastSelectedDay.dayId.slice(0, 4)}</p>
			{/if}

			<!-- <p class="label">Termin anlegen</p> -->
		</div>
		<div style="margin-top: -2rem" class="separator" />

		<div class="wrapper-form">
			<!-- ******************************************************** -->
			<!-- DOGS -->
			<!-- ******************************************************** -->
			<p class="label color-dark">{loc.appointments.labels.dogs}</p>
			<div class="display-flex mt-8">
				<!-- svelte-ignore a11y-no-onchange -->
				<select bind:this={dropdownSelectDogs} bind:value={selectedDog} on:change={addDog} class:selected={appointmentData.dogs.length > 0}>
					<option value="" disabled selected>{loc.shared.misc.pleaseSelect}</option>
					{#each fetchedDogs as dog}
						<option value={dog}>{dog.name}</option>
					{/each}
				</select>
				<button on:click={addAllDogs} class="btn btn-regular ml-8">{loc.appointments.misc.btnAddAllDogs}</button>
			</div>
			{#if appointmentValidationErrors.dogs}
				<p class="form-validation-error mt-8">({appointmentValidationErrors.dogs})</p>
			{/if}
			<!-- ----------------------------------------------------- -->
			<!-- LIST OF ADDED DOGS -->
			<!-- ----------------------------------------------------- -->
			<div class="wrapper-list">
				{#each appointmentData.dogs as dog}
					<div class="list-item mt-8 regular-text">
						{dog.name}
						<button on:click={() => removeDog(dog)} class="btn btn-w-icon">
							<svg width="16" height="16" viewBox="0 0 11 11" fill="none" xmlns="http://www.w3.org/2000/svg">
								<path
									fill-rule="evenodd"
									clip-rule="evenodd"
									d="M10.2476 10.1872C9.95471 10.4801 9.47984 10.4801 9.18695 10.1872L1.18719 2.18718C0.894302 1.89428 0.894309 1.41941 1.18721 1.12652C1.4801 0.833633 1.95498 0.83364 2.24787 1.12654L10.2476 9.12654C10.5405 9.41944 10.5405 9.89431 10.2476 10.1872Z"
									fill="var(--dark)"
								/>
								<path
									fill-rule="evenodd"
									clip-rule="evenodd"
									d="M10.2479 1.12652C10.5407 1.41941 10.5408 1.89428 10.2479 2.18718L2.24811 10.1872C1.95522 10.4801 1.48035 10.4801 1.18745 10.1872C0.894554 9.89431 0.894547 9.41944 1.18744 9.12654L9.18719 1.12654C9.48008 0.83364 9.95495 0.833633 10.2479 1.12652Z"
									fill="var(--dark)"
								/>
							</svg>
						</button>
					</div>
				{/each}
			</div>
			<!-- ******************************************************** -->
			<!-- CARETAKER -->
			<!-- ******************************************************** -->
			<p class="label color-dark mt-20">{loc.appointments.labels.caretaker}</p>
			<div class="display-flex mt-8">
				<!-- svelte-ignore a11y-no-onchange -->
				<select
					bind:this={dropdownSelectCaretaker}
					bind:value={selectedCaretaker}
					on:change={addCaretaker}
					class:selected={appointmentData.caretaker !== null}
				>
					<option value="" disabled selected>{loc.shared.misc.pleaseSelect}</option>
					{#each fetchedContacts as contact}
						<option value={contact}>{contact.username}</option>
					{/each}
				</select>
			</div>
			{#if appointmentValidationErrors.caretaker}
				<p class="form-validation-error mt-8">({appointmentValidationErrors.caretaker})</p>
			{/if}
			<!-- ----------------------------------------------------- -->
			<!-- ADDED CARETAKER -->
			<!-- ----------------------------------------------------- -->
			{#if appointmentData.caretaker !== null}
				<div class="wrapper-list">
					<div class="list-item mt-8 regular-text">
						{appointmentData.caretaker.username}
						<button on:click={() => removeCaretaker(appointmentData.caretaker)} class="btn btn-w-icon">
							<svg width="16" height="16" viewBox="0 0 11 11" fill="none" xmlns="http://www.w3.org/2000/svg">
								<path
									fill-rule="evenodd"
									clip-rule="evenodd"
									d="M10.2476 10.1872C9.95471 10.4801 9.47984 10.4801 9.18695 10.1872L1.18719 2.18718C0.894302 1.89428 0.894309 1.41941 1.18721 1.12652C1.4801 0.833633 1.95498 0.83364 2.24787 1.12654L10.2476 9.12654C10.5405 9.41944 10.5405 9.89431 10.2476 10.1872Z"
									fill="var(--dark)"
								/>
								<path
									fill-rule="evenodd"
									clip-rule="evenodd"
									d="M10.2479 1.12652C10.5407 1.41941 10.5408 1.89428 10.2479 2.18718L2.24811 10.1872C1.95522 10.4801 1.48035 10.4801 1.18745 10.1872C0.894554 9.89431 0.894547 9.41944 1.18744 9.12654L9.18719 1.12654C9.48008 0.83364 9.95495 0.833633 10.2479 1.12652Z"
									fill="var(--dark)"
								/>
							</svg>
						</button>
					</div>
				</div>
			{/if}
			<!-- ******************************************************** -->
			<!-- OBSERVERS -->
			<!-- ******************************************************** -->
			<p class="label color-dark mt-20">{loc.appointments.labels.observers}</p>
			<div class="display-flex mt-8">
				<!-- svelte-ignore a11y-no-onchange -->
				<select
					bind:this={dropdownSelectObserver}
					bind:value={selectedObserver}
					on:change={addObserver}
					class:selected={appointmentData.observers.length > 0}
				>
					<option value="" disabled selected>{loc.shared.misc.pleaseSelect}</option>
					{#each fetchedContacts as contact}
						<option value={contact}>{contact.username}</option>
					{/each}
				</select>
			</div>
			{#if appointmentValidationErrors.observers}
				<p class="form-validation-error mt-8">({appointmentValidationErrors.observers})</p>
			{/if}
			<!-- ----------------------------------------------------- -->
			<!-- LIST OF ADDED OBSERVERS -->
			<!-- ----------------------------------------------------- -->
			<div class="wrapper-list">
				{#each appointmentData.observers as observer}
					<div class="list-item mt-8 regular-text">
						{observer.username}
						<button on:click={() => removeObserver(observer)} class="btn btn-w-icon">
							<svg width="16" height="16" viewBox="0 0 11 11" fill="none" xmlns="http://www.w3.org/2000/svg">
								<path
									fill-rule="evenodd"
									clip-rule="evenodd"
									d="M10.2476 10.1872C9.95471 10.4801 9.47984 10.4801 9.18695 10.1872L1.18719 2.18718C0.894302 1.89428 0.894309 1.41941 1.18721 1.12652C1.4801 0.833633 1.95498 0.83364 2.24787 1.12654L10.2476 9.12654C10.5405 9.41944 10.5405 9.89431 10.2476 10.1872Z"
									fill="var(--dark)"
								/>
								<path
									fill-rule="evenodd"
									clip-rule="evenodd"
									d="M10.2479 1.12652C10.5407 1.41941 10.5408 1.89428 10.2479 2.18718L2.24811 10.1872C1.95522 10.4801 1.48035 10.4801 1.18745 10.1872C0.894554 9.89431 0.894547 9.41944 1.18744 9.12654L9.18719 1.12654C9.48008 0.83364 9.95495 0.833633 10.2479 1.12652Z"
									fill="var(--dark)"
								/>
							</svg>
						</button>
					</div>
				{/each}
			</div>
			<!-- ******************************************************** -->
			<!-- START TIME -->
			<!-- ******************************************************** -->
			<!-- DROPDOWN TO ADD TIME -->
			<p class="label color-dark mt-20">{loc.appointments.labels.arrival}</p>
			<div style="display: flex;">
				<div class="wrapper-selects mt-8">
					<div class="datepicker-toggle mr-8">
						<div class:selected={startDate_date} class="datepicker-toggle-button">
							{#if startDate_date}
								{dateToString(startDate_date, null, "short")}
							{:else}
								Datum
							{/if}
						</div>
						<input
							bind:value={startDate_date}
							on:change={() => {
								const dateParts = startDate_date.split("-");
								const startDate = new Date(parseInt(dateParts[0]), parseInt(dateParts[1]) - 1, parseInt(dateParts[2]));
								if (startDate_time.hour && startDate_time.minute) {
									startDate.setHours(parseInt(startDate_time.hour), parseInt(startDate_time.minute));
								}
								appointmentData.start_date = startDate.toISOString();
							}}
							type="date"
							class="datepicker-input"
						/>
					</div>
				</div>
				<div class="wrapper-selects mt-8">
					<!-- svelte-ignore a11y-no-onchange -->
					<select bind:value={startDate_time.hour} on:change={setStartdate} class:selected={startDate_time.hour}>
						<option value="" disabled selected>{loc.shared.labels.hoursShort}</option>
						{#each { length: 24 } as _, i}
							<option>{String(leadingZero(i))}</option>
						{/each}
					</select>
					<!-- svelte-ignore a11y-no-onchange -->
					<select bind:value={startDate_time.minute} on:change={setStartdate} class="ml-8" class:selected={startDate_time.minute}>
						<option value="" disabled selected>{loc.shared.labels.minutesShort}</option>
						<option>00</option>
						<option>15</option>
						<option>30</option>
						<option>45</option>
					</select>
					<p class="regular-text ml-8">{loc.shared.labels.time}</p>
				</div>
			</div>

			{#if appointmentValidationErrors.start_date}
				<p class="form-validation-error mt-8">({appointmentValidationErrors.start_date})</p>
			{:else if (!startDate_time.hour || !startDate_time.minute) && $liveValidation && startDate_date}
				<p class="form-validation-error mt-8">({loc.appointments.val.startDateProvide})</p>
			{/if}
			<!-- ******************************************************** -->
			<!-- END TIME/DATE -->
			<!-- ******************************************************** -->
			<!-- DROPDOWN TO ADD TIME -->
			<p class="label color-dark mt-20">{loc.appointments.labels.departure}</p>
			<!-- DATE SELECT -->
			<!-- svelte-ignore a11y-no-onchange -->
			<div style="display: flex;">
				<div class="wrapper-selects mt-8">
					<div class="datepicker-toggle mr-8">
						<div class:selected={endDate_date} class="datepicker-toggle-button">
							{#if endDate_date}
								{dateToString(endDate_date, null, "short")}
							{:else}
								{loc.shared.labels.date}
							{/if}
						</div>
						<input
							bind:value={endDate_date}
							on:change={() => {
								const dateParts = endDate_date.split("-");
								const endDate = new Date(parseInt(dateParts[0]), parseInt(dateParts[1]) - 1, parseInt(dateParts[2]));
								if (endDate_time.hour && endDate_time.minute) {
									endDate.setHours(parseInt(endDate_time.hour), parseInt(endDate_time.minute));
								}
								appointmentData.end_date = endDate.toISOString();
								console.log(appointmentData.end_date);
							}}
							type="date"
							class="datepicker-input"
						/>
					</div>
				</div>
				<div class="wrapper-selects mt-8">
					<!-- svelte-ignore a11y-no-onchange -->

					<select bind:value={endDate_time.hour} on:change={setEnddate} class:selected={endDate_time.hour}>
						<option value="" disabled selected>{loc.shared.labels.hoursShort}</option>
						{#each { length: 24 } as _, i}
							<option>{String(leadingZero(i))}</option>
						{/each}
					</select>
					<!-- svelte-ignore a11y-no-onchange -->
					<select bind:value={endDate_time.minute} on:change={setEnddate} class="ml-8" class:selected={endDate_time.minute}>
						<option value="" disabled selected>{loc.shared.labels.minutesShort}</option>
						<option>00</option>
						<option>15</option>
						<option>30</option>
						<option>45</option>
					</select>
					<p class="regular-text ml-8">{loc.shared.labels.time}</p>
				</div>
			</div>

			{#if appointmentValidationErrors.end_date}
				<p class="form-validation-error mt-8">({appointmentValidationErrors.end_date})</p>
			{:else if (!endDate_time.hour || !endDate_time.minute) && $liveValidation && endDate_date}
				<p class="form-validation-error mt-8">({loc.appointments.val.endDateProvide})</p>
			{/if}
			<!-- ******************************************************** -->
			<!-- NOTES -->
			<!-- ******************************************************** -->
			<p class="label color-dark mt-32">{loc.shared.labels.notes}</p>
			<div>
				<textarea bind:value={appointmentData.notes} class="notes-input mt-8" cols="30" rows="10" />
			</div>
		</div>
	</div>
{/await}

<style>
</style>
