<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="Onni.User.Registration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script>
        /* For disappearing alert message */
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%= lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Registration Form Begin -->
    <div class="contact-form spad">
        <div class="container">
            <div class="heading_container">
                <div class="contact__form__title text-right">
                    <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="text-danger d-block mt-2" />
                </div>
                <div class="contact__form__title text-center">
                    <asp:Label ID="lblHeaderMsg" runat="server" Text="Регистрация Пользователя" CssClass="h2" />
                </div>
            </div>
            <div class="row justify-content-center">
                <div class="col-lg-4">
                    <div class="bg-light border rounded shadow p-4">
                        <!-- Name -->
                        <div class="mb-3">
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Требуется имя" ControlToValidate="txtName"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revName" runat="server" ErrorMessage="Имя должно состоять только из символов."
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Zа-яА-ЯёЁ\s]+$"
                                ControlToValidate="txtName"></asp:RegularExpressionValidator>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Имя"
                                ToolTip="Full Name"></asp:TextBox>
                        </div>

                        <!-- Username -->
                        <div class="mb-3">
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ErrorMessage="Требуется имя пользователя"
                                ControlToValidate="txtUsername" ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revUsername" runat="server" ControlToValidate="txtUsername"
                                ValidationExpression="^[a-zA-Z0-9_]{3,20}$" ErrorMessage="Имя пользователя должно состоять из латинских символов"
                                ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Логин"
                                ToolTip="Username"></asp:TextBox>
                        </div>

                        <!-- Email -->
                        <div class="mb-3">
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ErrorMessage="Требуется электронная почта"
                                ControlToValidate="txtEmail" ForeColor="Red" Display="Dynamic" SetFocusOnError="true">
                            </asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email"
                                ToolTip="Email" TextMode="Email"></asp:TextBox>
                        </div>

                        <!-- Phone Number -->
                        <div class="mb-3">
                            <!-- Обязательность -->
                            <asp:RequiredFieldValidator ID="rfvPhoneNumber" runat="server" ControlToValidate="txtPhoneNumber"
                                ErrorMessage="Номер телефона" ForeColor="Red" Display="Dynamic" SetFocusOnError="true">
                            </asp:RequiredFieldValidator>
                            <!-- Ровно 9 цифр -->
                            <asp:RegularExpressionValidator ID="revPhoneNumber" runat="server" ControlToValidate="txtPhoneNumber"
                                ValidationExpression="^\d{9}$" ErrorMessage="Номер должен содержать 9 цифр" ForeColor="Red" Display="Dynamic"
                                SetFocusOnError="true"></asp:RegularExpressionValidator>
                            <!-- Само поле -->
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">+996</span>
                                </div>
                                <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control" MaxLength="9" placeholder="XXX XX XX XX">
                                </asp:TextBox>
                            </div>
                        </div>

                        <!-- Address -->
                        <div class="mb-3">
                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ErrorMessage="Требуется адрес"
                                ControlToValidate="txtAddress"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Адрес"
                                ToolTip="Address" TextMode="MultiLine"></asp:TextBox>
                        </div>

                        <!-- Password -->
                        <div class="mb-3">
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                ErrorMessage="Введите пароль"
                                ControlToValidate="txtPassword" ForeColor="Red"
                                Display="Dynamic" SetFocusOnError="true" />
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Пароль"
                                ToolTip="Password" TextMode="Password"></asp:TextBox>
                        </div>

                        <!-- Register Button -->
                        <div class="text-center mt-4">
                            <asp:Button ID="btnRegister" runat="server" Text="Зарегистрироваться" CssClass="site-btn"
                                OnClick="btnRegister_Click" />
                        </div>

                        <!-- Already Registered -->
                        <div class="text-center mt-2">
                            <asp:Label ID="lblAlreadyUser" runat="server"
                                Text="Уже зарегистрированы? <a href='Login.aspx' class='badge badge-info'>Войти</a>" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
