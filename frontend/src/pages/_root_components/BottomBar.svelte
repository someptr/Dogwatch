<script>
	import { menuContext, menuSelection, bottomBarAction, liveValidation } from "../../stores/state";
	import { goto } from "@roxi/routify";
	import { fade } from "svelte/transition";

	import { en } from "../../loc/en";
	import { de } from "../../loc/de";
	let loc;
	navigator.language.slice(0, 2) === "de" ? (loc = de) : (loc = en);

	let menuVisible = false;
	let menuOpacity = 0;
	let menuPointer = "none";
	let radius = 0;

	// ----------------------------------------------
	// GENERAL
	// ----------------------------------------------

	function toggleMenu(e) {
		if (menuVisible) {
			menuOpacity = 0;
			menuPointer = "none";
			radius = 0;
		} else {
			menuOpacity = 100;
			menuPointer = "auto";
			radius = 0;
		}
		menuVisible = !menuVisible;
	}

	// ----------------------------------------------
	// CRUD CALENDAR
	// ----------------------------------------------
	function addAppointment() {
		$goto("/appointments/add");
	}
	function saveAppointment() {
		liveValidation.set(true);
		bottomBarAction.set("appointment_save");
	}

	// ----------------------------------------------
	// CRUD DOGS
	// ----------------------------------------------
	function editDog() {
		$goto(`/dogs/edit/${$menuContext.idToUse}`);
	}
	function deleteDog() {
		bottomBarAction.set("dog_delete");
	}
	function addDog() {
		$goto("/dogs/add");
	}
	function saveDog() {
		liveValidation.set(true);
		bottomBarAction.set("dog_save");
	}
</script>

<!-- ----------------------------------------- -->
<!-- // MENU -->
<!-- ----------------------------------------- -->

<!-- Menu Wrapper -->
<div on:click|stopPropagation={toggleMenu} style="opacity: {menuOpacity}%; pointer-events: {menuPointer}" class="wrapper-menu">
	<!-- 'X' Button to close Menu -->
	<!-- <button class="x" on:click|stopPropagation={toggleMenu}>
		<svg class="x" width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path
				d="M2 22.0005C17.3043 6.69611 21.7101 2.29031 22 2.00046"
				stroke="var(--color-bottom-menu-icons)"
				stroke-width="3"
				stroke-linecap="round"
				stroke-linejoin="round"
			/>
			<path
				d="M22 22C6.69565 6.69565 2.28985 2.28986 2 2"
				stroke="var(--color-bottom-menu-icons)"
				stroke-width="3"
				stroke-linecap="round"
				stroke-linejoin="round"
			/>
		</svg>
	</button> -->
	<!-- Button "Logout" -->
	<div class="wrapper-btn-menu-link">
		<button
			class:menu-selected={$menuSelection === "logout"}
			on:click|stopPropagation={toggleMenu}
			on:click={() => menuSelection.set("logout")}
			on:click={() => $goto("/logout")}
			class="menu-link"
			>{loc.globals.menu.logout}
			<svg
				class="icon-menu"
				class:icon-active={$menuSelection === "logout"}
				width="18"
				height="20"
				viewBox="0 0 18 20"
				fill="none"
				xmlns="http://www.w3.org/2000/svg"
			>
				<path
					fill-rule="evenodd"
					d="M0 2C0 .9.9 0 2 0h8v2H2v14h8v2H2c-1.1 0-2-.9-2-2V2zm14.176 6L11.64 5.464l1.414-1.414L18.004 9l-4.95 4.95-1.414-1.414L14.176 10H7.59V8h6.586z"
					fill="var(--color-bottom-menu-icons)"
				/>
			</svg></button
		>
	</div>
	<!-- Button "Profile" -->
	<div class="wrapper-btn-menu-link">
		<button
			class:menu-selected={$menuSelection === "profile"}
			on:click|stopPropagation={toggleMenu}
			on:click={() => menuSelection.set("profile")}
			on:click={() => $goto("/profile")}
			class="menu-link"
			>{loc.globals.menu.profile}
			<svg
				class="icon-menu"
				class:icon-active={$menuSelection === "profile"}
				width="18"
				height="20"
				viewBox="0 0 18 20"
				fill="none"
				xmlns="http://www.w3.org/2000/svg"
			>
				<path
					d="M5.4 11.3162C6.55312 11.3162 7.10759 11.9118 9 11.9118C10.8924 11.9118 11.4429 11.3162 12.6 11.3162C15.5813 11.3162 18 13.5571 18 16.3191V17.2721C18 18.2585 17.1362 19.0588 16.0714 19.0588H1.92857C0.86384 19.0588 2.38419e-07 18.2585 2.38419e-07 17.2721V16.3191C2.38419e-07 13.5571 2.41875 11.3162 5.4 11.3162ZM1.92857 17.2721H16.0714V16.3191C16.0714 14.5472 14.5125 13.1029 12.6 13.1029C12.0134 13.1029 11.0612 13.6985 9 13.6985C6.92277 13.6985 5.99062 13.1029 5.4 13.1029C3.4875 13.1029 1.92857 14.5472 1.92857 16.3191V17.2721ZM9 10.7206C5.8058 10.7206 3.21429 8.31962 3.21429 5.36029C3.21429 2.40096 5.8058 0 9 0C12.1942 0 14.7857 2.40096 14.7857 5.36029C14.7857 8.31962 12.1942 10.7206 9 10.7206ZM9 1.78676C6.87455 1.78676 5.14286 3.39113 5.14286 5.36029C5.14286 7.32946 6.87455 8.93382 9 8.93382C11.1254 8.93382 12.8571 7.32946 12.8571 5.36029C12.8571 3.39113 11.1254 1.78676 9 1.78676Z"
					fill="var(--color-bottom-menu-icons)"
				/>
			</svg></button
		>
	</div>
	<!-- Button "Contacts" -->
	<div class="wrapper-btn-menu-link">
		<button
			class:menu-selected={$menuSelection === "contacts"}
			on:click|stopPropagation={toggleMenu}
			on:click={() => menuSelection.set("contacts")}
			on:click={() => $goto("/contacts/list")}
			class="menu-link"
			>{loc.globals.menu.contacts}
			<svg
				xmlns="http://www.w3.org/2000/svg"
				class="icon-menu"
				class:icon-active={$menuSelection === "profile"}
				width="17"
				height="20"
				fill="none"
				xmlns:v="https://vecta.io/nano"
				><path
					d="M11.5 10.25a.75.75 0 0 0-.75-.75h-5a.75.75 0 0 0-.75.75v.5c0 1 1.383 1.75 3.25 1.75s3.25-.75 3.25-1.75v-.5zM10 6.745C10 5.78 9.217 5 8.25 5S6.5 5.779 6.5 6.745a1.75 1.75 0 0 0 1.75 1.75A1.75 1.75 0 0 0 10 6.745h0zM0 2.5A2.5 2.5 0 0 1 2.5 0H14a2.5 2.5 0 0 1 .957.19 2.5 2.5 0 0 1 1.353 1.353 2.5 2.5 0 0 1 .19.957v14.25a.75.75 0 0 1-.75.75H1.5a1 1 0 0 0 1 1h13.25a.75.75 0 0 1 .75.75.75.75 0 0 1-.75.75H2.5A2.5 2.5 0 0 1 0 17.5v-15zm1.5 0V16H15V2.5a1 1 0 0 0-1-1H2.5a1 1 0 0 0-1 1z"
					fill="var(--color-bottom-menu-icons)"
				/></svg
			></button
		>
	</div>
	<!-- Button "Dogs" -->
	<div class="wrapper-btn-menu-link">
		<button
			class:menu-selected={$menuSelection === "dogs"}
			on:click|stopPropagation={toggleMenu}
			on:click={() => menuSelection.set("dogs")}
			on:click={() => $goto("/dogs")}
			class="menu-link"
			>{loc.globals.menu.dogs}
			<svg
				class="icon-menu"
				class:icon-active={$menuSelection === "dogs"}
				width="20"
				height="15"
				viewBox="0 0 20 15"
				fill="none"
				xmlns="http://www.w3.org/2000/svg"
			>
				<path
					d="M6.81573 1.95316C5.29394 2.02466 4.30437 2.28516 3.69177 2.79817C3.5155 2.94578 3.25545 3.34785 2.9952 4.10698C2.74905 4.82498 2.54743 5.72514 2.39208 6.70413C2.14422 8.2661 2.0254 9.95518 2.01093 11.2858H3.68565C4.52273 11.2858 5.14037 10.8274 5.61655 10.1544C6.10071 9.47007 6.32744 8.70391 6.37063 8.4821L6.37513 8.46038L6.82099 6.42915C6.93554 5.90725 7.46855 5.57343 8.01148 5.68355C8.55442 5.79367 8.90169 6.30602 8.78713 6.82792L8.34339 8.84952C8.25749 9.27984 7.94421 10.2992 7.27814 11.2406C6.59776 12.2023 5.44191 13.2174 3.68565 13.2174H3.34851L2.66654 14.9959H0.581943L1.29661 13.2174H1.01543C0.472926 13.2174 0.0283964 12.8034 0.0112126 12.2822C-0.0388861 10.7626 0.0765083 8.48686 0.40562 6.41286C0.570179 5.37584 0.792597 4.36036 1.08672 3.50242C1.36675 2.6856 1.76322 1.85141 2.37183 1.34175C3.52205 0.378527 5.10438 0.0996837 6.71763 0.0238836C7.85034 -0.0293382 9.14446 0.0163919 10.4852 0.0637691C11.0563 0.0839491 11.6358 0.104428 12.2149 0.117686C12.5257 0.124802 12.8156 0.269847 13 0.510501L15.8031 4.1694L19.1484 4.66546C19.6384 4.73811 20 5.14342 20 5.61996V7.08895L20 7.09656L19.9999 7.13012C19.9998 7.15832 19.9994 7.19804 19.9983 7.24797C19.9963 7.34775 19.9918 7.48885 19.9821 7.66081C19.9627 8.00315 19.922 8.47565 19.836 8.99214C19.7505 9.50515 19.6166 10.085 19.402 10.6328C19.1911 11.1713 18.8763 11.7462 18.3893 12.1831C17.8837 12.6368 17.1555 12.9191 16.4942 13.1095C15.8013 13.3088 15.0354 13.4467 14.3391 13.5428C13.7207 13.6282 13.1386 13.6832 12.6822 13.718V15H10.6727V12.8095C10.6727 12.2886 11.1025 11.8616 11.644 11.8443L11.6457 11.8442L11.6537 11.8439L11.6891 11.8426C11.721 11.8413 11.7691 11.8393 11.8314 11.8362C11.9562 11.8302 12.1377 11.8201 12.3603 11.8045C12.8068 11.773 13.4122 11.7194 14.0534 11.6309C14.6989 11.5417 15.3572 11.4204 15.9179 11.259C16.51 11.0886 16.8647 10.9088 17.0183 10.771C17.1904 10.6166 17.3667 10.3473 17.5215 9.95211C17.6726 9.56626 17.7792 9.12298 17.8518 8.68681C17.9239 8.25412 17.9589 7.85134 17.9756 7.55572C17.9839 7.4087 17.9877 7.29014 17.9893 7.21C17.9901 7.16998 17.9904 7.13967 17.9905 7.12035L17.9906 7.09979L17.9906 7.09673L17.9906 7.09639L17.9906 7.09601L17.9905 7.08895V6.44818L15.0869 6.01761C14.8244 5.97868 14.5886 5.84141 14.4311 5.63581L11.6732 2.03601C11.201 2.02264 10.746 2.0065 10.307 1.99093L10.3068 1.99093C9.01361 1.94506 7.85929 1.90412 6.81573 1.95316Z"
					fill="var(--color-bottom-menu-icons)"
				/>
			</svg></button
		>
	</div>
	<!-- Button "Appointments" -->
	<div class="wrapper-btn-menu-link">
		<button
			class:menu-selected={$menuSelection === "appointments"}
			on:click|stopPropagation={toggleMenu}
			on:click={() => menuSelection.set("appointments")}
			on:click={() => $goto("/appointments")}
			class="menu-link"
			>{loc.globals.menu.appointments}
			<svg
				class="icon-menu"
				class:icon-active={$menuSelection === "appointments"}
				width="17"
				height="18"
				viewBox="0 0 17 18"
				fill="none"
				xmlns="http://www.w3.org/2000/svg"
			>
				<path
					d="M1.82143 2.25H3.64286V0.421875C3.64286 0.189844 3.84777 0 4.09821 0H5.61607C5.86652 0 6.07143 0.189844 6.07143 0.421875V2.25H10.9286V0.421875C10.9286 0.189844 11.1335 0 11.3839 0H12.9018C13.1522 0 13.3571 0.189844 13.3571 0.421875V2.25H15.1786C16.1842 2.25 17 3.00586 17 3.9375V16.3125C17 17.2441 16.1842 18 15.1786 18H1.82143C0.815848 18 -4.74862e-07 17.2441 -4.74862e-07 16.3125V3.9375C-4.74862e-07 3.00586 0.815848 2.25 1.82143 2.25ZM2.04911 16.3125H14.9509C15.0761 16.3125 15.1786 16.2176 15.1786 16.1016V5.625H1.82143V16.1016C1.82143 16.2176 1.92388 16.3125 2.04911 16.3125Z"
					fill="var(--color-bottom-menu-icons)"
				/>
			</svg></button
		>
	</div>
</div>
<!-- BottomBar -->
<div on:click|stopPropagation={toggleMenu} style="border-top-left-radius:{radius}px; border-top-right-radius:{radius}px" class="wrapper-bottombar">
	<!-- ----------------------------------------- -->
	<!-- // CONTEXT: day (ADD) -->
	<!-- ----------------------------------------- -->
	{#if $menuContext.context === "day"}
		<div class="wrapper-context-icons">
			<button in:fade class="icon" on:click|stopPropagation={addAppointment}>
				<svg width="25" height="25" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path
						d="M25.1429 14.8571V17.1429C25.1429 17.6143 24.7571 18 24.2857 18H18V24.2857C18 24.7571 17.6143 25.1429 17.1429 25.1429H14.8571C14.3857 25.1429 14 24.7571 14 24.2857V18H7.71429C7.24286 18 6.85714 17.6143 6.85714 17.1429V14.8571C6.85714 14.3857 7.24286 14 7.71429 14H14V7.71429C14 7.24286 14.3857 6.85714 14.8571 6.85714H17.1429C17.6143 6.85714 18 7.24286 18 7.71429V14H24.2857C24.7571 14 25.1429 14.3857 25.1429 14.8571ZM32 3.42857V28.5714C32 30.4643 30.4643 32 28.5714 32H3.42857C1.53571 32 0 30.4643 0 28.5714V3.42857C0 1.53571 1.53571 0 3.42857 0H28.5714C30.4643 0 32 1.53571 32 3.42857ZM28.5714 28.1429V3.85714C28.5714 3.62143 28.3786 3.42857 28.1429 3.42857H3.85714C3.62143 3.42857 3.42857 3.62143 3.42857 3.85714V28.1429C3.42857 28.3786 3.62143 28.5714 3.85714 28.5714H28.1429C28.3786 28.5714 28.5714 28.3786 28.5714 28.1429Z"
						fill="var(--color-bottom-bar-icons)"
					/>
				</svg>
			</button>
		</div>
	{/if}

	<!-- ----------------------------------------- -->
	<!-- // CONTEXT: dog_add (GO BACK, SAVE) -->
	<!-- ----------------------------------------- -->
	{#if $menuContext.context === "dog_add"}
		<div class="wrapper-context-icons">
			<button in:fade class="icon" on:click|stopPropagation={() => window.history.back()}>
				<svg width="40" height="25" viewBox="0 0 48 32" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path
						fill-rule="evenodd"
						clip-rule="evenodd"
						d="M43.7595 0C45.5816 0 47.0588 1.45955 47.0588 3.26V28.74C47.0588 30.5405 45.5816 32 43.7595 32H16.565C15.7062 32 14.8812 31.6691 14.2654 31.0777L0.999748 18.3377C0.360609 17.7239 0 16.8807 0 16C0 15.1193 0.360609 14.2761 0.999748 13.6623L14.2654 0.922308C14.8812 0.330869 15.7062 0 16.565 0H43.7595ZM16.565 28.74L3.29936 16L16.565 3.26H43.7595V28.74H16.565Z"
						fill="var(--color-bottom-bar-icons)"
					/>
					<path
						fill-rule="evenodd"
						clip-rule="evenodd"
						d="M38.3308 7.52946C39.0759 8.2354 39.0759 9.37993 38.3308 10.0859L23.1468 24.4706C22.4017 25.1765 21.1936 25.1765 20.4485 24.4705C19.7034 23.7646 19.7034 22.6201 20.4485 21.9142L35.6325 7.52943C36.3776 6.82351 37.5857 6.82353 38.3308 7.52946Z"
						fill="var(--color-bottom-bar-icons)"
					/>
					<path
						fill-rule="evenodd"
						clip-rule="evenodd"
						d="M20.4485 7.52946C21.1936 6.82353 22.4017 6.82351 23.1468 7.52943L38.3308 21.9141C39.0759 22.6201 39.0759 23.7646 38.3308 24.4705C37.5857 25.1765 36.3776 25.1765 35.6325 24.4706L20.4485 10.0858C19.7034 9.37993 19.7034 8.2354 20.4485 7.52946Z"
						fill="var(--color-bottom-bar-icons)"
					/>
				</svg>
			</button>
			<button in:fade class="icon" on:click|stopPropagation={saveDog}>
				<svg width="25" height="25" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path
						d="M30.9958 6.99579L25.0042 1.00421C24.3612 0.361231 23.4892 4.75483e-06 22.5799 0H3.42857C1.535 0 0 1.535 0 3.42857V28.5714C0 30.465 1.535 32 3.42857 32H28.5714C30.465 32 32 30.465 32 28.5714V9.42014C32 8.51083 31.6388 7.63876 30.9958 6.99579V6.99579ZM19.4286 3.42857V9.14286H10.2857V3.42857H19.4286ZM28.1429 28.5714H3.85714C3.74348 28.5714 3.63447 28.5263 3.5541 28.4459C3.47372 28.3655 3.42857 28.2565 3.42857 28.1429V3.85714C3.42857 3.74348 3.47372 3.63447 3.5541 3.5541C3.63447 3.47372 3.74348 3.42857 3.85714 3.42857H6.85714V10.8571C6.85714 11.8039 7.62464 12.5714 8.57143 12.5714H21.1429C22.0896 12.5714 22.8571 11.8039 22.8571 10.8571V3.70586L28.4459 9.29464C28.4857 9.33444 28.5173 9.3817 28.5388 9.4337C28.5604 9.4857 28.5714 9.54143 28.5714 9.59771V28.1429C28.5714 28.2565 28.5263 28.3655 28.4459 28.4459C28.3655 28.5263 28.2565 28.5714 28.1429 28.5714V28.5714ZM16 14.2857C12.5341 14.2857 9.71429 17.1055 9.71429 20.5714C9.71429 24.0374 12.5341 26.8571 16 26.8571C19.4659 26.8571 22.2857 24.0374 22.2857 20.5714C22.2857 17.1055 19.4659 14.2857 16 14.2857ZM16 23.4286C14.4246 23.4286 13.1429 22.1469 13.1429 20.5714C13.1429 18.996 14.4246 17.7143 16 17.7143C17.5754 17.7143 18.8571 18.996 18.8571 20.5714C18.8571 22.1469 17.5754 23.4286 16 23.4286Z"
						fill="var(--color-bottom-bar-icons)"
					/>
				</svg>
			</button>
		</div>
	{/if}

	<!-- ----------------------------------------- -->
	<!-- // CONTEXT: dog_none (ADD) -->
	<!-- ----------------------------------------- -->

	{#if $menuContext.context === "dog_none"}
		<div class="wrapper-context-icons">
			<button in:fade class="icon" on:click|stopPropagation={addDog}>
				<svg width="25" height="25" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path
						d="M25.1429 14.8571V17.1429C25.1429 17.6143 24.7571 18 24.2857 18H18V24.2857C18 24.7571 17.6143 25.1429 17.1429 25.1429H14.8571C14.3857 25.1429 14 24.7571 14 24.2857V18H7.71429C7.24286 18 6.85714 17.6143 6.85714 17.1429V14.8571C6.85714 14.3857 7.24286 14 7.71429 14H14V7.71429C14 7.24286 14.3857 6.85714 14.8571 6.85714H17.1429C17.6143 6.85714 18 7.24286 18 7.71429V14H24.2857C24.7571 14 25.1429 14.3857 25.1429 14.8571ZM32 3.42857V28.5714C32 30.4643 30.4643 32 28.5714 32H3.42857C1.53571 32 0 30.4643 0 28.5714V3.42857C0 1.53571 1.53571 0 3.42857 0H28.5714C30.4643 0 32 1.53571 32 3.42857ZM28.5714 28.1429V3.85714C28.5714 3.62143 28.3786 3.42857 28.1429 3.42857H3.85714C3.62143 3.42857 3.42857 3.62143 3.42857 3.85714V28.1429C3.42857 28.3786 3.62143 28.5714 3.85714 28.5714H28.1429C28.3786 28.5714 28.5714 28.3786 28.5714 28.1429Z"
						fill="var(--color-bottom-bar-icons)"
					/>
				</svg>
			</button>
		</div>
	{/if}

	<!-- ----------------------------------------- -->
	<!-- // CONTEXT: dog (DELETE, EDIT, ADD) -->
	<!-- ----------------------------------------- -->
	{#if $menuContext.context === "dog"}
		<div class="wrapper-context-icons">
			<button in:fade class="icon" on:click|stopPropagation={deleteDog}>
				<svg width="25" height="30" viewBox="0 0 32 38" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path
						d="M19.1429 30.2449H20.8571C21.0845 30.2449 21.3025 30.153 21.4632 29.9894C21.624 29.8257 21.7143 29.6038 21.7143 29.3725V13.6684C21.7143 13.437 21.624 13.2151 21.4632 13.0515C21.3025 12.8878 21.0845 12.7959 20.8571 12.7959H19.1429C18.9155 12.7959 18.6975 12.8878 18.5368 13.0515C18.376 13.2151 18.2857 13.437 18.2857 13.6684V29.3725C18.2857 29.6038 18.376 29.8257 18.5368 29.9894C18.6975 30.153 18.9155 30.2449 19.1429 30.2449ZM30.8571 5.81633H24.9707L22.5421 1.69401C22.2374 1.17709 21.8062 0.749355 21.2907 0.452479C20.7752 0.155603 20.193 -0.000286701 19.6007 3.95834e-07H12.3993C11.8072 -3.55355e-05 11.2253 0.155974 10.7101 0.452837C10.1949 0.749701 9.76394 1.1773 9.45929 1.69401L7.02929 5.81633H1.14286C0.839753 5.81633 0.549062 5.93889 0.334735 6.15704C0.120408 6.37519 0 6.67108 0 6.97959L0 8.14286C0 8.45138 0.120408 8.74726 0.334735 8.96541C0.549062 9.18357 0.839753 9.30612 1.14286 9.30612H2.28571V33.7347C2.28571 34.6602 2.64694 35.5479 3.28992 36.2024C3.9329 36.8568 4.80497 37.2245 5.71429 37.2245H26.2857C27.195 37.2245 28.0671 36.8568 28.7101 36.2024C29.3531 35.5479 29.7143 34.6602 29.7143 33.7347V9.30612H30.8571C31.1602 9.30612 31.4509 9.18357 31.6653 8.96541C31.8796 8.74726 32 8.45138 32 8.14286V6.97959C32 6.67108 31.8796 6.37519 31.6653 6.15704C31.4509 5.93889 31.1602 5.81633 30.8571 5.81633ZM12.2743 3.70137C12.3125 3.63665 12.3665 3.58314 12.4311 3.54605C12.4957 3.50897 12.5687 3.48958 12.6429 3.4898H19.3571C19.4312 3.48971 19.504 3.50915 19.5685 3.54623C19.6329 3.58331 19.6869 3.63676 19.725 3.70137L20.9721 5.81633H11.0279L12.2743 3.70137ZM26.2857 33.7347H5.71429V9.30612H26.2857V33.7347ZM11.1429 30.2449H12.8571C13.0845 30.2449 13.3025 30.153 13.4632 29.9894C13.624 29.8257 13.7143 29.6038 13.7143 29.3725V13.6684C13.7143 13.437 13.624 13.2151 13.4632 13.0515C13.3025 12.8878 13.0845 12.7959 12.8571 12.7959H11.1429C10.9155 12.7959 10.6975 12.8878 10.5368 13.0515C10.376 13.2151 10.2857 13.437 10.2857 13.6684V29.3725C10.2857 29.6038 10.376 29.8257 10.5368 29.9894C10.6975 30.153 10.9155 30.2449 11.1429 30.2449Z"
						fill="var(--color-bottom-bar-icons)"
					/>
				</svg>
			</button>
			<button in:fade class="icon" on:click|stopPropagation={editDog} style="margin-bottom: 0.15rem">
				<svg width="32" height="30" viewBox="0 0 42 37" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path
						d="M29.335 24.9262L31.6684 22.614C32.033 22.2527 32.6674 22.5056 32.6674 23.0259V33.5318C32.6674 35.4465 31.0996 37 29.1673 37H3.50008C1.56774 37 0 35.4465 0 33.5318V8.09798C0 6.18322 1.56774 4.62974 3.50008 4.62974H23.4432C23.9609 4.62974 24.2234 5.25113 23.8589 5.61964L21.5255 7.9318C21.4161 8.04018 21.2703 8.09798 21.1098 8.09798H3.50008V33.5318H29.1673V25.3308C29.1673 25.1791 29.2256 25.0346 29.335 24.9262ZM40.754 10.3451L21.6057 29.3193L15.0139 30.0418C13.1034 30.2514 11.4773 28.6545 11.6888 26.747L12.418 20.2152L31.5663 1.24098C33.2361 -0.41366 35.9341 -0.41366 37.5966 1.24098L40.7467 4.3624C42.4165 6.01704 42.4165 8.6977 40.754 10.3451V10.3451ZM33.5497 12.5778L29.3131 8.37978L15.7649 21.812L15.2326 26.5302L19.9942 26.0028L33.5497 12.5778ZM38.2748 6.81907L35.1247 3.69765C34.8258 3.40141 34.3372 3.40141 34.0455 3.69765L31.7924 5.93033L36.0289 10.1284L38.2821 7.89567C38.5738 7.5922 38.5738 7.11531 38.2748 6.81907V6.81907Z"
						fill="var(--color-bottom-bar-icons)"
					/>
				</svg>
			</button>
			<button in:fade class="icon" on:click|stopPropagation={addDog}>
				<svg width="25" height="25" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path
						d="M25.1429 14.8571V17.1429C25.1429 17.6143 24.7571 18 24.2857 18H18V24.2857C18 24.7571 17.6143 25.1429 17.1429 25.1429H14.8571C14.3857 25.1429 14 24.7571 14 24.2857V18H7.71429C7.24286 18 6.85714 17.6143 6.85714 17.1429V14.8571C6.85714 14.3857 7.24286 14 7.71429 14H14V7.71429C14 7.24286 14.3857 6.85714 14.8571 6.85714H17.1429C17.6143 6.85714 18 7.24286 18 7.71429V14H24.2857C24.7571 14 25.1429 14.3857 25.1429 14.8571ZM32 3.42857V28.5714C32 30.4643 30.4643 32 28.5714 32H3.42857C1.53571 32 0 30.4643 0 28.5714V3.42857C0 1.53571 1.53571 0 3.42857 0H28.5714C30.4643 0 32 1.53571 32 3.42857ZM28.5714 28.1429V3.85714C28.5714 3.62143 28.3786 3.42857 28.1429 3.42857H3.85714C3.62143 3.42857 3.42857 3.62143 3.42857 3.85714V28.1429C3.42857 28.3786 3.62143 28.5714 3.85714 28.5714H28.1429C28.3786 28.5714 28.5714 28.3786 28.5714 28.1429Z"
						fill="var(--color-bottom-bar-icons)"
					/>
				</svg>
			</button>
		</div>
	{/if}

	<!-- ----------------------------------------- -->
	<!-- // CONTEXT: appointment_add (GO BACK, SAVE) -->
	<!-- ----------------------------------------- -->
	{#if $menuContext.context === "appointment_add"}
		<div class="wrapper-context-icons">
			<button in:fade class="icon" on:click|stopPropagation={() => window.history.back()}>
				<svg width="40" height="25" viewBox="0 0 48 32" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path
						fill-rule="evenodd"
						clip-rule="evenodd"
						d="M43.7595 0C45.5816 0 47.0588 1.45955 47.0588 3.26V28.74C47.0588 30.5405 45.5816 32 43.7595 32H16.565C15.7062 32 14.8812 31.6691 14.2654 31.0777L0.999748 18.3377C0.360609 17.7239 0 16.8807 0 16C0 15.1193 0.360609 14.2761 0.999748 13.6623L14.2654 0.922308C14.8812 0.330869 15.7062 0 16.565 0H43.7595ZM16.565 28.74L3.29936 16L16.565 3.26H43.7595V28.74H16.565Z"
						fill="var(--color-bottom-bar-icons)"
					/>
					<path
						fill-rule="evenodd"
						clip-rule="evenodd"
						d="M38.3308 7.52946C39.0759 8.2354 39.0759 9.37993 38.3308 10.0859L23.1468 24.4706C22.4017 25.1765 21.1936 25.1765 20.4485 24.4705C19.7034 23.7646 19.7034 22.6201 20.4485 21.9142L35.6325 7.52943C36.3776 6.82351 37.5857 6.82353 38.3308 7.52946Z"
						fill="var(--color-bottom-bar-icons)"
					/>
					<path
						fill-rule="evenodd"
						clip-rule="evenodd"
						d="M20.4485 7.52946C21.1936 6.82353 22.4017 6.82351 23.1468 7.52943L38.3308 21.9141C39.0759 22.6201 39.0759 23.7646 38.3308 24.4705C37.5857 25.1765 36.3776 25.1765 35.6325 24.4706L20.4485 10.0858C19.7034 9.37993 19.7034 8.2354 20.4485 7.52946Z"
						fill="var(--color-bottom-bar-icons)"
					/>
				</svg>
			</button>
			<button in:fade class="icon" on:click|stopPropagation={saveAppointment}>
				<svg width="25" height="25" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path
						d="M30.9958 6.99579L25.0042 1.00421C24.3612 0.361231 23.4892 4.75483e-06 22.5799 0H3.42857C1.535 0 0 1.535 0 3.42857V28.5714C0 30.465 1.535 32 3.42857 32H28.5714C30.465 32 32 30.465 32 28.5714V9.42014C32 8.51083 31.6388 7.63876 30.9958 6.99579V6.99579ZM19.4286 3.42857V9.14286H10.2857V3.42857H19.4286ZM28.1429 28.5714H3.85714C3.74348 28.5714 3.63447 28.5263 3.5541 28.4459C3.47372 28.3655 3.42857 28.2565 3.42857 28.1429V3.85714C3.42857 3.74348 3.47372 3.63447 3.5541 3.5541C3.63447 3.47372 3.74348 3.42857 3.85714 3.42857H6.85714V10.8571C6.85714 11.8039 7.62464 12.5714 8.57143 12.5714H21.1429C22.0896 12.5714 22.8571 11.8039 22.8571 10.8571V3.70586L28.4459 9.29464C28.4857 9.33444 28.5173 9.3817 28.5388 9.4337C28.5604 9.4857 28.5714 9.54143 28.5714 9.59771V28.1429C28.5714 28.2565 28.5263 28.3655 28.4459 28.4459C28.3655 28.5263 28.2565 28.5714 28.1429 28.5714V28.5714ZM16 14.2857C12.5341 14.2857 9.71429 17.1055 9.71429 20.5714C9.71429 24.0374 12.5341 26.8571 16 26.8571C19.4659 26.8571 22.2857 24.0374 22.2857 20.5714C22.2857 17.1055 19.4659 14.2857 16 14.2857ZM16 23.4286C14.4246 23.4286 13.1429 22.1469 13.1429 20.5714C13.1429 18.996 14.4246 17.7143 16 17.7143C17.5754 17.7143 18.8571 18.996 18.8571 20.5714C18.8571 22.1469 17.5754 23.4286 16 23.4286Z"
						fill="var(--color-bottom-bar-icons)"
					/>
				</svg>
			</button>
		</div>
	{/if}

	<!-- ----------------------------------------- -->
	<!-- // HAMBURGER ICON (always rendered) -->
	<!-- ----------------------------------------- -->
	<div />
	<div class="wrapper-hamburger-icon" class:rotate={menuVisible}>
		<button in:fade on:click|stopPropagation={toggleMenu}>
			<svg class="hamburger" width="27" height="25" viewBox="0 0 32 30" fill="none" xmlns="http://www.w3.org/2000/svg">
				<path
					fill-rule="evenodd"
					clip-rule="evenodd"
					d="M0 2.12885C0 0.953119 0.765028 0 1.70874 0H30.2913C31.235 0 32 0.953119 32 2.12885C32 3.30458 31.235 4.2577 30.2913 4.2577H1.70874C0.765028 4.2577 0 3.30458 0 2.12885Z"
					fill="var(--color-bottom-bar-icons)"
				/>
				<path
					fill-rule="evenodd"
					clip-rule="evenodd"
					d="M0 27.6751C0 26.4994 0.765028 25.5463 1.70874 25.5463H30.2913C31.235 25.5463 32 26.4994 32 27.6751C32 28.8508 31.235 29.804 30.2913 29.804H1.70874C0.765028 29.804 0 28.8508 0 27.6751Z"
					fill="var(--color-bottom-bar-icons)"
				/>
				<path
					fill-rule="evenodd"
					clip-rule="evenodd"
					d="M0 14.9019C0 13.7262 0.765028 12.7731 1.70874 12.7731H30.2913C31.235 12.7731 32 13.7262 32 14.9019C32 16.0777 31.235 17.0308 30.2913 17.0308H1.70874C0.765028 17.0308 0 16.0777 0 14.9019Z"
					fill="var(--color-bottom-bar-icons)"
				/>
			</svg>
		</button>
	</div>
</div>

<style>
	.wrapper-bottombar {
		position: fixed;
		padding: 0rem 2rem;
		bottom: 0;
		left: 0;
		width: 100%;
		width: 100%;
		margin-left: 0;
		height: var(--bottombar-height);
		background-color: var(--light);
		display: flex;
		align-items: center;
		justify-content: space-between;
		transition: 0.2s;
		border-left: 5px solid white;
		border-right: 5px solid white;
		background: var(--color-bottom-bar-bg);
	}

	.rotate {
		transition: 0.2s;
		transition-timing-function: ease-in-out;
		transform: rotate(90deg);
	}

	.wrapper-hamburger-icon {
		transition: 0.2s;
		transition-timing-function: ease-in-out;
	}

	button.menu-link {
		text-decoration: none;
		font-weight: 800;
		color: var(--color-bottom-menu-icons);
		height: 4rem;
		font-size: 2.4rem;
		display: flex;
		align-items: center;
		font-family: "Nunito";
		letter-spacing: normal;
	}

	button.menu-link:hover {
		color: var(--bright);
	}

	button.menu-selected {
		color: var(--bright) !important;
	}

	button.menu-selected svg > path {
		fill: var(--bright) !important;
	}

	button.menu-link:hover svg > path {
		fill: var(--bright);
	}

	.wrapper-btn-menu-link {
		display: flex;
		justify-content: center;
		align-items: center;
		margin-right: 0.2rem;
		margin-top: 0.5rem;
		margin-bottom: 0.5rem;
	}

	.wrapper-menu {
		padding: 1rem 2.4rem;
		position: fixed;
		height: 30rem;
		bottom: calc(var(--bottombar-height) + 0.2rem);
		background: var(--color-bottom-menu-bg);
		display: flex;
		left: 0;
		width: 100%;
		transition: 0.3s;
		flex-direction: column;
		align-items: flex-end;
		justify-content: center;
		z-index: 3;
		border-top-left-radius: 15px;
		border-top-right-radius: 15px;
		border-bottom: 2px solid var(--bright);
		border-left: 5px solid var(--bg-color);
		border-right: 5px solid var(--bg-color);
		border-top: 5px solid var(--bg-color);
	}

	.wrapper-context-icons {
		display: flex;
		align-items: center;
	}

	.icon-menu {
		margin-left: 1rem;
	}

	.icon-active path {
		fill: var(--contrast);
	}

	svg.hamburger:hover path {
		fill: var(--color-bottom-menu-icons);
	}

	svg.x:hover path {
		fill: var(--color-bottom-menu-icons);
		stroke: var(--color-bottom-menu-icons);
	}

	button {
		background: none;
		border: none;
		cursor: pointer;
	}

	button.x {
		width: 48px;
		height: 48px;
	}

	button.x {
		margin-right: -1.3rem;
	}
</style>
