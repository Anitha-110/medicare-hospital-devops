const modal = document.getElementById("appointmentModal");


function openAppointment() {
    modal.classList.add("active");
    document.body.style.overflow = "hidden";
}


function closeAppointment() {
    modal.classList.remove("active");
    document.body.style.overflow = "auto";
}


modal.addEventListener("click", function (event) {

    if (event.target === modal) {
        closeAppointment();
    }

});


document.addEventListener("keydown", function (event) {

    if (event.key === "Escape") {
        closeAppointment();
    }

});


function submitAppointment(event) {

    event.preventDefault();

    alert(
        "Thank you! Your appointment request has been submitted successfully."
    );

    event.target.reset();

    closeAppointment();
}
