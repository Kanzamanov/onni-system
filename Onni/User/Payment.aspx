<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="Onni.User.Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .rounded {
            border-radius: 1rem
        }

        .nav-pills .nav-link {
            color: #555
        }

            .nav-pills .nav-link.active {
                color: white
            }

        .bold {
            font-weight: bold
        }

        .card {
            padding: 40px 50px;
            border-radius: 20px;
            border: none;
            box-shadow: 1px 5px 10px 1px rgba(0, 0, 0, 0.2)
        }
    </style>
    <script>
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };
        $(function () {
            $('[data-toggle="tooltip"]').tooltip()
        })
    </script>

    <script type="text/javascript">
        function DisableBackButton() {
            window.history.forward()
        }
        DisableBackButton();
        window.onload = DisableBackButton;
        window.onpageshow = function (evt) { if (evt.persisted) DisableBackButton() }
        window.onunload = function () { void (0) }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <section class="book_section" style="background-image: url('../Images/payment-bg.png'); width: 100%; height: 100%; background-repeat: no-repeat; background-size: auto; background-attachment: fixed; background-position: left;">

        <div class="container py-5">
            <div class="text-right">
                <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
            </div>
            <div class="row mb-4">
                <div class="col-lg-8 mx-auto text-center">
                    <h2 class="display-6">Оплата заказа</h2>
                </div>
            </div>
            <div class="row pb-5">
                <div class="col-lg-6 mx-auto">
                    <div class="card ">
                        <div class="card-header">
                            <div class="bg-white shadow-sm pt-4 pl-2 pr-2 pb-2">
                                <ul role="tablist" class="nav bg-light nav-pills rounded nav-fill mb-3">
                                    <li class="nav-item"><a data-toggle="pill" href="#credit-card" class="nav-link active "><i class="fa fa-credit-card mr-2"></i>Картой </a></li>
                                    <li class="nav-item"><a data-toggle="pill" href="#paypal" class="nav-link "><i class="fa fa-money mr-2"></i>Наличными </a></li>
                                </ul>
                            </div>
                            <div class="tab-content">
                                <div id="credit-card" class="tab-pane fade show active pt-3">
                                    <div role="form">
                                        <div class="form-group">
                                            <label for="txtName">
                                                <h6>Владелец карты</h6>
                                            </label>
                                            <asp:RequiredFieldValidator ID="rfvName" runat="server"
                                                ErrorMessage="Поле 'Имя' обязательно для заполнения"
                                                ControlToValidate="txtName" ForeColor="Red" Display="Dynamic"
                                                SetFocusOnError="true" ValidationGroup="card">*
                                            </asp:RequiredFieldValidator>

                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                                ErrorMessage="Имя должно быть указано в символах" ForeColor="Red" Display="Dynamic" SetFocusOnError="true"
                                                ValidationExpression="^[a-zA-Z\s]+$" ControlToValidate="txtName" ValidationGroup="card">
                                                *
                                            </asp:RegularExpressionValidator>
                                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Имя владельца карты"></asp:TextBox>
                                        </div>
                                        <div class="form-group">
                                            <label for="txtCardNo">
                                                <h6>Номер карты</h6>
                                            </label>
                                            <asp:RequiredFieldValidator ID="rfvCardNo" runat="server"
                                                ErrorMessage="Поле 'Номер карты' обязательно для заполнения"
                                                ControlToValidate="txtCardNo" ForeColor="Red" Display="Dynamic"
                                                SetFocusOnError="true" ValidationGroup="card">*
                                            </asp:RequiredFieldValidator>

                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                                                ErrorMessage="Номер карты должен состоять из 16 цифр" ForeColor="Red" Display="Dynamic" SetFocusOnError="true"
                                                ValidationExpression="[0-9]{16}" ControlToValidate="txtCardNo" ValidationGroup="card">
                                                *
                                            </asp:RegularExpressionValidator>
                                            <div class="input-group">
                                                <asp:TextBox ID="txtCardNo" runat="server" CssClass="form-control" placeholder="Действующий номер карты"
                                                    TextMode="Number">
                                                </asp:TextBox>
                                                <div class="input-group-append">
                                                    <span class="input-group-text text-muted">
                                                        <i class="fa fa-cc-visa mx-1"></i>
                                                        <i class="fa fa-cc-mastercard mx-1"></i>
                                                        <i class="fa fa-cc-amex mx-1"></i>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-8">
                                                <div class="form-group">
                                                    <label>
                                                        <span class="hidden-xs">
                                                            <h6>Срок действия</h6>
                                                        </span>
                                                    </label>
                                                    <asp:RequiredFieldValidator ID="rfvExpMonth" runat="server"
                                                        ErrorMessage="Поле 'Месяц окончания срока действия' обязательно для заполнения"
                                                        ControlToValidate="txtExpMonth" ForeColor="Red" Display="Dynamic"
                                                        SetFocusOnError="true" ValidationGroup="card">*
                                                    </asp:RequiredFieldValidator>

                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" Display="Dynamic"
                                                        ErrorMessage="Месяц истечения срока должен состоять из 2 цифр" ForeColor="Red" SetFocusOnError="true"
                                                        ValidationExpression="[0-9]{2}" ControlToValidate="txtExpMonth" ValidationGroup="card">
                                                        *
                                                    </asp:RegularExpressionValidator>
                                                    <asp:RequiredFieldValidator ID="rfvExpYear" runat="server"
                                                        ErrorMessage="Укажите год окончания действия карты"
                                                        ControlToValidate="txtExpYear" ForeColor="Red" Display="Dynamic" SetFocusOnError="true"
                                                        ValidationGroup="card">*
                                                    </asp:RequiredFieldValidator>

                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" Display="Dynamic"
                                                        ErrorMessage="Год истечения срока должен состоять из 4 цифр" ForeColor="Red" SetFocusOnError="true"
                                                        ValidationExpression="[0-9]{4}" ControlToValidate="txtExpYear" ValidationGroup="card">
                                                        *
                                                    </asp:RegularExpressionValidator>
                                                    <div class="input-group">
                                                        <asp:TextBox ID="txtExpMonth" runat="server" CssClass="form-control" placeholder="ММ"
                                                            TextMode="Number">
                                                        </asp:TextBox>
                                                        <asp:TextBox ID="txtExpYear" runat="server" CssClass="form-control" placeholder="ГГГГ"
                                                            TextMode="Number">
                                                        </asp:TextBox>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-sm-4">
                                                <div class="form-group mb-4">
                                                    <label data-toggle="tooltip" title="Три цифры на обратной стороне карты">
                                                        <h6>CVV <i class="fa fa-question-circle d-inline"></i></h6>
                                                    </label>
                                                    <asp:RequiredFieldValidator ID="rfvCvv" runat="server"
                                                        ErrorMessage="Укажите код CVV"
                                                        ControlToValidate="txtCvv" ForeColor="Red" Display="Dynamic" SetFocusOnError="true"
                                                        ValidationGroup="card">*
                                                    </asp:RequiredFieldValidator>

                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" Display="Dynamic"
                                                        ErrorMessage="Номер CVV должен состоять из 3 цифр" ForeColor="Red" SetFocusOnError="true"
                                                        ValidationExpression="[0-9]{3}" ControlToValidate="txtCvv" ValidationGroup="card">
                                                        *
                                                    </asp:RegularExpressionValidator>
                                                    <asp:TextBox ID="txtCvv" runat="server" CssClass="form-control" placeholder="CVV"
                                                        TextMode="Number">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="txtAddress">
                                                <h6>Адрес доставки</h6>
                                            </label>
                                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
                                                ErrorMessage="Укажите адрес"
                                                ControlToValidate="txtAddress" ForeColor="Red" Display="Dynamic" SetFocusOnError="true"
                                                ValidationGroup="card">*
                                            </asp:RequiredFieldValidator>
                                            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Введите адрес доставки"
                                                TextMode="MultiLine" ValidationGroup="card">
                                            </asp:TextBox>
                                        </div>
                                        <div class="card-footer">
                                            <asp:LinkButton ID="lbCardSubmit" runat="server" CssClass="subscribe btn btn-info btn-block shadow-sm"
                                                ValidationGroup="card" OnClick="lbCardSubmit_Click">
                                               Оплатить</asp:LinkButton>
                                        </div>
                                    </div>
                                </div>
                                <div id="paypal" class="tab-pane fade pt-3">
                                    <div class="form-group">
                                        <label for="txtCODAddress">
                                            <h6>Адрес доставки</h6>
                                        </label>
                                        <asp:TextBox ID="txtCODAddress" runat="server" CssClass="form-control" placeholder="Введите адрес доставки"
                                            TextMode="MultiLine">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="rfvCODAddress" runat="server"
                                            ControlToValidate="txtCODAddress" ErrorMessage="Укажите адрес доставки" Text="* Укажите адрес доставки"
                                            ForeColor="Red" Display="Dynamic" SetFocusOnError="true" ValidationGroup="cod" Font-Names="Segoe UI">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                    <p>
                                        <asp:LinkButton ID="lbCodSubmit" runat="server" CssClass="btn btn-info" ValidationGroup="cod" OnClick="lbCodSubmit_Click">
                                            <i class="fa fa-cart-arrow-down mr-2"></i>Подтвердить заказ</asp:LinkButton>
                                    </p>
                                    <p class="text-muted">
                                        Примечание: при получении заказа вы должны будете оплатить полную стоимость.  
                                        После завершения процесса оплаты вы сможете отслеживать статус своего заказа.
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <b class="badge badge-success badge-pill shadow-sm">Итого к оплате:
                                <asp:Literal ID="ltGrandTotal" runat="server" />сом
                            </b>
                            <div class="pt-2">
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                                    CssClass="alert alert-danger rounded shadow-sm px-4 py-2"
                                    ValidationGroup="card"
                                    HeaderText="Пожалуйста, исправьте следующие ошибки:"
                                    Font-Names="Segoe UI" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>

